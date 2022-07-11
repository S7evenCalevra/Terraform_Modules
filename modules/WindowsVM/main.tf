data "azurerm_resource_group" "keyvault_rg" {
  name = "${var.keyvault_rg}"
}

data "azurerm_key_vault" "keyvault" {
  name = "${var.keyvault_name}"
  resource_group_name = "${data.azurerm_resource_group.keyvault_rg.name}"
}

data "azurerm_key_vault_secret" "VmToken" {
  name = "${var.keyvault_token}"
  key_vault_id = "${data.azurerm_key_vault.keyvault.id}"
}


data "azurerm_resource_group" "vm_rg" {
  name = var.resource_group
}

resource "azurerm_network_interface" "vm_nic" {
  count               = var.vm_network_interface_count
  name                = "${var.vm_machine_name}-nic${count.index}"
  location            = data.azurerm_resource_group.vm_rg.location
  resource_group_name = data.azurerm_resource_group.vm_rg.name

  ip_configuration {
    name                          = "${var.vm_machine_name}-nic${count.index}"
    private_ip_address_allocation = "Dynamic"
  }
}

locals {
  vm_nics = chunklist(azurerm_network_interface.vm_nic[*].id, var.vm_network_interface_count)
}

resource "azurerm_windows_virtual_machine" "vm_winvm" {
  count               = var.vm_count
  name                = "${var.vm_machine_name}-${count.index}"
  resource_group_name = data.azurerm_resource_group.vm_rg.name
  location            = data.azurerm_resource_group.vm_rg.location
  size                = var.vm_size
  admin_username      = "adminuser"
  admin_password      = "${data.azurerm_key_vault_secret.VmToken.value}"
  network_interface_ids = element(local.vm_nics, count.index)
  

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = var.vm_os_disk_size
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
}

locals {
  vm_machines = chunklist(azurerm_windows_virtual_machine.vm_winvm[*].id, var.vm_count)
}

resource "azurerm_managed_disk" "vm_datadisk1" {
  count               = var.vm_count
  name                 = "${var.vm_machine_name}-${count.index}-disk1"
  resource_group_name = data.azurerm_resource_group.vm_rg.name
  location            = data.azurerm_resource_group.vm_rg.location
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = var.vm_data_disk_size_1
  depends_on           = [
      azurerm_windows_virtual_machine.vm_winvm
    ]
}

locals {
  vm_datadisks1 = chunklist(azurerm_managed_disk.vm_datadisk1[*].id, var.vm_count)
}

resource "azurerm_virtual_machine_data_disk_attachment" "vm_datadisk1_attach" {
  count               = var.vm_count
  managed_disk_id    = element(local.vm_datadisks1, count.index)
  virtual_machine_id = element(local.vm_machines, count.index)
  lun                = "10"
  caching            = "ReadWrite"
  depends_on         = [
    azurerm_managed_disk.vm_datadisk1
    ]
}
