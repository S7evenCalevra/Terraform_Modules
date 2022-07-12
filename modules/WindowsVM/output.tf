output "created_vms" {
  value = azurerm_windows_virtual_machine.vm_winvm[*]
}
