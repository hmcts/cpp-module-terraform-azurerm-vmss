moved {
  from = azurerm_linux_virtual_machine_scale_set.linux_vmss
  to   = azurerm_linux_virtual_machine_scale_set.linux_vmss[0]
}
