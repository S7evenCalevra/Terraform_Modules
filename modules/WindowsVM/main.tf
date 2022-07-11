data "azurerm_resource_group" "keyvault_rg" {
  name = "TerraformIACTest"
}

data "azurerm_key_vault" "keyvault" {
  name = "terraffirniac-kv"
  resource_group_name = "${data.azurerm_resource_group.keyvault_rg.name}"
}

data "azurerm_key_vault_secret" "VmToken" {
  name = "testVMToken"
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
    subnet_id                     = data.azurerm_subnet.vm_sn.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "vm_winvm" {
  count               = var.vm_count
  name                = "${var.vm_machine_name}-${count.index}"
  resource_group_name = data.azurerm_resource_group.vm_rg.name
  location            = data.azurerm_resource_group.vm_rg.location
  size                = var.vm_size
  admin_username      = "adminuser"
  admin_password      = "${data.azurerm_key_vault_secret.VmToken.value}"
  network_interface_ids = azurerm_network_interface.vm_nic.*.id
  

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

resource "azurerm_managed_disk" "vm_datadisk1" {
  name                 = "${var.vm_machine_name}-disk1"
  resource_group_name = data.azurerm_resource_group.vm_rg.name
  location            = data.azurerm_resource_group.vm_rg.location
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = var.vm_data_disk_size_1
}

resource "azurerm_virtual_machine_data_disk_attachment" "vm_datadisk1_attach" {
  managed_disk_id    = azurerm_managed_disk.vm_datadisk1.id
  virtual_machine_id = azurerm_windows_virtual_machine.vm_winvm.id
  lun                = "10"
  caching            = "ReadWrite"
}

resource "azurerm_managed_disk" "vm_datadisk2" {
  name                 = "${var.vm_machine_name}-disk2"
  resource_group_name = data.azurerm_resource_group.vm_rg.name
  location            = data.azurerm_resource_group.vm_rg.location
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = var.vm_data_disk_size_2
}

resource "azurerm_virtual_machine_data_disk_attachment" "vm_datadisk2_attach" {
  managed_disk_id    = azurerm_managed_disk.vm_datadisk2.id
  virtual_machine_id = azurerm_windows_virtual_machine.vm_winvm.id
  lun                = "11"
  caching            = "ReadWrite"
}

