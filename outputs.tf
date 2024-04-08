output "admin_ssh_key_public" {
  description = "The generated public key data in PEM format"
  value       = var.generate_admin_ssh_key == true ? tls_private_key.rsa[0].public_key_openssh : null
}

output "load_balancer_private_ip" {
  description = "The Private IP address allocated for load balancer"
  value       = var.load_balancer_type == "private" ? element(concat(azurerm_lb.vmsslb.*.private_ip_address, [""]), 0) : null
}

output "load_balancer_nat_pool_id" {
  description = "The resource ID of the Load Balancer NAT pool."
  value       = var.enable_lb_nat_pool ? element(concat(azurerm_lb_nat_pool.natpol.*.id, [""]), 0) : null
}

output "load_balancer_health_probe_id" {
  description = "The resource ID of the Load Balancer health Probe."
  value       = var.enable_load_balancer ? element(concat(azurerm_lb_probe.lbp.*.id, [""]), 0) : null
}

output "load_balancer_rules_id" {
  description = "The resource ID of the Load Balancer Rule"
  value       = var.enable_load_balancer ? element(concat(azurerm_lb_rule.lbrule.*.id, [""]), 0) : null
}

output "linux_virtual_machine_scale_set_name" {
  description = "The name of the Linux Virtual Machine Scale Set."
  value       = element(concat(azurerm_linux_virtual_machine_scale_set.linux_vmss.*.name, [""]), 0)
}

output "linux_virtual_machine_scale_set_id" {
  description = "The resource ID of the Linux Virtual Machine Scale Set."
  value       = element(concat(azurerm_linux_virtual_machine_scale_set.linux_vmss.*.id, [""]), 0)
}

output "linux_virtual_machine_scale_set_unique_id" {
  description = "The unique ID of the Linux Virtual Machine Scale Set."
  value       = element(concat(azurerm_linux_virtual_machine_scale_set.linux_vmss.*.unique_id, [""]), 0)
}

output "load_balancer_public_ip" {
  value = var.load_balancer_type == "public" ? (azurerm_public_ip.vmss_lb_public_ip[0].ip_address) : "Not applicable for private load balancers"
}
