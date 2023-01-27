resource "random_id" "name" {
  byte_length = 8
}

resource "azurerm_resource_group" "vmss" {
  name     = format("${var.resource_group_name}-%s", random_id.name.hex)
  location = var.location
  tags     = var.tags
}

resource "azurerm_subnet" "vmss" {
  name                 = var.subnet_config.name
  resource_group_name  = var.subnet_config.resource_group_name
  virtual_network_name = var.subnet_config.virtual_network_name
  address_prefixes     = [var.subnet_config.address_prefixes]
}

resource "azurerm_network_security_group" "vmss" {
  name                = format("acceptancetestsecgroup1-%s", random_id.name.hex)
  location            = var.location
  resource_group_name = azurerm_resource_group.vmss.name

  security_rule {
    name                       = "test123"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = var.tags
}

data "azurerm_key_vault" "key_vault" {
  name                = var.key_vault_config.name
  resource_group_name = var.key_vault_config.resource_group_name
}

module "vmss" {
  source                    = "../"
  resource_group_name       = azurerm_resource_group.vmss.name
  location                  = var.location
  subnet_id                 = azurerm_subnet.vmss.id
  network_security_group_id = azurerm_network_security_group.vmss.id
  key_vault_id              = data.azurerm_key_vault.key_vault.id
  vmscaleset_name           = var.vmss_config.name
  linux_distribution_name   = var.vmss_config.linux_distribution_name
  source_image_id           = var.vmss_config.source_image_id
  isImageFromMarketPlace    = false
  generate_admin_ssh_key    = true
  instances_count           = 1
  enable_load_balancer      = false
  enable_autoscale_for_vmss = false
  tags                      = var.tags
}
