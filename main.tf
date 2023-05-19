resource "tls_private_key" "rsa" {
  count     = var.generate_admin_ssh_key == true ? 1 : 0
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "random_password" "passwd" {
  count       = var.disable_password_authentication != true && var.admin_password == null ? 1 : 0
  length      = 24
  min_upper   = 4
  min_lower   = 2
  min_numeric = 4
  special     = false
}

resource "azurerm_key_vault_secret" "ssh_public_key" {
  count        = var.generate_admin_ssh_key == true ? 1 : 0
  name         = "ado--cpp-module-terraform-azurerm-vmss--${var.environment}--vmss-ssh-public-key"
  value        = tls_private_key.rsa[0].public_key_openssh
  key_vault_id = var.key_vault_id
}

resource "azurerm_key_vault_secret" "ssh_private_key" {
  count        = var.generate_admin_ssh_key == true ? 1 : 0
  name         = "ado--cpp-module-terraform-azurerm-vmss--${var.environment}--vmss-ssh-private-key"
  value        = tls_private_key.rsa[0].private_key_pem
  key_vault_id = var.key_vault_id
}

resource "azurerm_key_vault_secret" "password" {
  count        = var.disable_password_authentication != true && var.admin_password == null ? 1 : 0
  name         = "ado--cpp-module-terraform-azurerm-vmss--${var.environment}--vmss-admin-password"
  value        = random_password.passwd[0].result
  key_vault_id = var.key_vault_id
}

resource "azurerm_lb" "vmsslb" {
  count               = var.enable_load_balancer ? 1 : 0
  name                = lower("lbint-${var.vmscaleset_name}-${var.location}")
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.load_balancer_sku
  tags                = merge({ "ResourceName" = lower("lbint-${var.vmscaleset_name}-${var.location}") }, var.tags, )

  frontend_ip_configuration {
    name                          = lower("lbint-frontend-${var.vmscaleset_name}")
    public_ip_address_id          = null
    private_ip_address_allocation = var.load_balancer_type == "private" ? var.private_ip_address_allocation : null
    private_ip_address            = var.load_balancer_type == "private" && var.private_ip_address_allocation == "Static" ? var.lb_private_ip_address : null
    subnet_id                     = var.load_balancer_type == "private" ? var.subnet_id : null
  }
}

resource "azurerm_lb_backend_address_pool" "bepool" {
  count           = var.enable_load_balancer ? 1 : 0
  name            = lower("lbe-backend-pool-${var.vmscaleset_name}")
  loadbalancer_id = azurerm_lb.vmsslb[count.index].id
}

resource "azurerm_lb_nat_pool" "natpol" {
  count                          = var.enable_load_balancer && var.enable_lb_nat_pool ? 1 : 0
  name                           = lower("lbe-nat-pool-${var.vmscaleset_name}-${var.location}")
  resource_group_name            = var.resource_group_name
  loadbalancer_id                = azurerm_lb.vmsslb.0.id
  protocol                       = "Tcp"
  frontend_port_start            = var.nat_pool_frontend_ports[0]
  frontend_port_end              = var.nat_pool_frontend_ports[1]
  backend_port                   = 22
  frontend_ip_configuration_name = azurerm_lb.vmsslb.0.frontend_ip_configuration.0.name
}

resource "azurerm_lb_probe" "lbp" {
  count           = var.enable_load_balancer ? length(var.load_balancer_health_probe_port_list) : 0
  name            = lower("lb-probe-port-${var.load_balancer_health_probe_port_list[count.index]}-${var.vmscaleset_name}")
  loadbalancer_id = azurerm_lb.vmsslb[0].id
  port            = var.load_balancer_health_probe_port_list[count.index]
}

resource "azurerm_lb_rule" "lbrule" {
  count                          = var.enable_load_balancer ? length(var.load_balanced_port_list) : 0
  name                           = format("%s-%02d-rule", var.vmscaleset_name, count.index + 1)
  loadbalancer_id                = azurerm_lb.vmsslb[0].id
  probe_id                       = azurerm_lb_probe.lbp[count.index].id
  protocol                       = "Tcp"
  frontend_port                  = tostring(var.load_balanced_port_list[count.index]["frontend_port"])
  backend_port                   = tostring(var.load_balanced_port_list[count.index]["backend_port"])
  frontend_ip_configuration_name = azurerm_lb.vmsslb[0].frontend_ip_configuration.0.name
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.bepool[0].id]
}

resource "azurerm_linux_virtual_machine_scale_set" "linux_vmss" {
  name                            = var.vmscaleset_name
  resource_group_name             = var.resource_group_name
  location                        = var.location
  overprovision                   = var.overprovision
  sku                             = var.virtual_machine_size
  instances                       = var.instances_count
  zones                           = var.availability_zones
  zone_balance                    = var.availability_zone_balance
  single_placement_group          = var.single_placement_group
  admin_username                  = var.admin_username
  admin_password                  = var.disable_password_authentication != true && var.admin_password == null ? random_password.passwd[0].result : var.admin_password
  tags                            = merge({ "ResourceName" = var.vmscaleset_name }, var.tags, )
  source_image_id                 = var.source_image_id != null ? var.source_image_id : null
  upgrade_mode                    = var.os_upgrade_mode
  health_probe_id                 = var.enable_load_balancer ? azurerm_lb_probe.lbp[0].id : null
  provision_vm_agent              = true
  disable_password_authentication = var.disable_password_authentication
  custom_data                     = var.custom_data != null ? base64encode(var.custom_data) : null

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.generate_admin_ssh_key == true ? tls_private_key.rsa[0].public_key_openssh : file(var.admin_ssh_key_data)
  }

  dynamic "source_image_reference" {
    for_each = var.source_image_id != null ? [] : [1]
    content {
      publisher = var.custom_image != null ? var.custom_image["publisher"] : var.linux_distribution_list[lower(var.linux_distribution_name)]["publisher"]
      offer     = var.custom_image != null ? var.custom_image["offer"] : var.linux_distribution_list[lower(var.linux_distribution_name)]["offer"]
      sku       = var.custom_image != null ? var.custom_image["sku"] : var.linux_distribution_list[lower(var.linux_distribution_name)]["sku"]
      version   = var.custom_image != null ? var.custom_image["version"] : var.linux_distribution_list[lower(var.linux_distribution_name)]["version"]
    }
  }

  dynamic "plan" {
    for_each = var.isImageFromMarketPlace ? [1] : []
    content {
      name      = var.custom_image["sku"]
      publisher = var.custom_image["publisher"]
      product   = var.custom_image["offer"]
    }
  }

  os_disk {
    storage_account_type = var.os_disk_storage_account_type
    caching              = "ReadWrite"
  }

  dynamic "data_disk" {
    for_each = var.additional_data_disks
    content {
      lun                  = data_disk.key
      disk_size_gb         = data_disk.value
      caching              = "ReadWrite"
      storage_account_type = var.additional_data_disks_storage_account_type
    }
  }

  network_interface {
    name                          = lower("nic-${var.vmscaleset_name}")
    primary                       = true
    dns_servers                   = var.dns_servers
    enable_ip_forwarding          = var.enable_ip_forwarding
    enable_accelerated_networking = var.enable_accelerated_networking
    network_security_group_id     = var.network_security_group_id

    ip_configuration {
      name                                   = lower("ipconig-${var.vmscaleset_name}")
      primary                                = true
      subnet_id                              = var.subnet_id
      load_balancer_backend_address_pool_ids = var.enable_load_balancer ? [azurerm_lb_backend_address_pool.bepool[0].id] : null
      load_balancer_inbound_nat_rules_ids    = var.enable_load_balancer && var.enable_lb_nat_pool ? [azurerm_lb_nat_pool.natpol[0].id] : null
    }
  }

  automatic_instance_repair {
    enabled      = var.enable_automatic_instance_repair
    grace_period = var.grace_period
  }

  depends_on = [azurerm_lb_rule.lbrule]
}

resource "azurerm_monitor_autoscale_setting" "auto" {
  count               = var.enable_autoscale_for_vmss ? 1 : 0
  name                = lower("auto-scale-set-${var.vmscaleset_name}")
  resource_group_name = var.resource_group_name
  location            = var.location
  target_resource_id  = azurerm_linux_virtual_machine_scale_set.linux_vmss.id

  profile {
    name = "default"
    capacity {
      default = var.instances_count
      minimum = var.minimum_instances_count == null ? var.instances_count : var.minimum_instances_count
      maximum = var.maximum_instances_count
    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_linux_virtual_machine_scale_set.linux_vmss.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "GreaterThan"
        threshold          = var.scale_out_cpu_percentage_threshold
      }
      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = var.scaling_action_instances_number
        cooldown  = "PT1M"
      }
    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_linux_virtual_machine_scale_set.linux_vmss.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "LessThan"
        threshold          = var.scale_in_cpu_percentage_threshold
      }
      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = var.scaling_action_instances_number
        cooldown  = "PT1M"
      }
    }
  }
}

resource "azurerm_monitor_diagnostic_setting" "vmmsdiag" {
  count                      = var.log_analytics_workspace_id != null && var.storage_account_id != null ? 1 : 0
  name                       = lower("${var.vmscaleset_name}-diag")
  target_resource_id         = azurerm_linux_virtual_machine_scale_set.linux_vmss.id
  storage_account_id         = var.storage_account_id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  metric {
    category = "AllMetrics"

    retention_policy {
      enabled = false
    }
  }
}

resource "azurerm_monitor_diagnostic_setting" "nsg" {
  count                      = var.log_analytics_workspace_id != null && var.storage_account_id != null ? 1 : 0
  name                       = lower("nsg-${var.vmscaleset_name}-diag")
  target_resource_id         = var.network_security_group_id
  storage_account_id         = var.storage_account_id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  dynamic "log" {
    for_each = var.nsg_diag_logs
    content {
      category = log.value
      enabled  = true

      retention_policy {
        enabled = false
      }
    }
  }
}
