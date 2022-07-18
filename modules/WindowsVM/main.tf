locals {
  vm_datadiskdisk_count_map = { for k in toset(var.vm_names) : k => var.nb_disks_per_vm }
  luns                      = { for k in local.datadisk_lun_map : k.datadisk_name => k.lun }
  datadisk_lun_map = flatten([
    for vm_name, count in local.vm_datadiskdisk_count_map : [
      for i in range(count) : {
        datadisk_name = format("datadisk_%s_disk%02d", vm_name, i)
        lun           = i
      }
    ]
  ])
  vm_nic_count_map = { for k in toset(var.vm_names) : k => var.nb_nics_per_vm }
  nic_count        = { for k in local.nic_count_map : k.nic_name => k.nic_num }
  nic_count_map = flatten([
    for vm_name, count in local.vm_nic_count_map : [
      for i in range(count) : {
        nic_name = format("%s_nic_%02d", vm_name, i)
        nic_num           = vm_name
      }
    ]
  ])
}

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

data "azurerm_virtual_network" "vm_vn" {
  name                = var.vm_network
  resource_group_name = data.azurerm_resource_group.vm_rg.name
}

data "azurerm_subnet" "vm_sn" {
  name                 = var.vm_network_subnet
  resource_group_name  = data.azurerm_resource_group.vm_rg.name
  virtual_network_name = data.azurerm_virtual_network.vm_vn.name
}

resource "azurerm_network_interface" "vm_nic" {
  #for_each               = toset([for j in local.nic_count_map : j.nic_name])
  for_each               = toset(var.vm_names)
  name                = "${each.key}-nic0"
  location            = data.azurerm_resource_group.vm_rg.location
  resource_group_name = data.azurerm_resource_group.vm_rg.name

  ip_configuration {
    name                          = "${each.key}-nic0config"
    subnet_id                     = data.azurerm_subnet.vm_sn.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "vm_winvm" {
  for_each               = toset(var.vm_names)
  name                = each.key
  resource_group_name = data.azurerm_resource_group.vm_rg.name
  location            = data.azurerm_resource_group.vm_rg.location
  size                = var.vm_size
  admin_username      = "adminuser"
  admin_password      = "${data.azurerm_key_vault_secret.VmToken.value}"
  network_interface_ids = [azurerm_network_interface.vm_nic[each.key].id]
  
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = var.vm_os_disk_size
    name                 = "${each.key}-osdisk"
  }
  
  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
  
  #tags = var.tags
}

resource "azurerm_managed_disk" "managed_disk" {
  for_each             = toset([for j in local.datadisk_lun_map : j.datadisk_name])
  name                 = each.key
  location             = data.azurerm_resource_group.vm_rg.location
  resource_group_name  = data.azurerm_resource_group.vm_rg.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = vm_data_disk_size_1
  #tags                 = var.tags
}

resource "azurerm_virtual_machine_data_disk_attachment" "managed_disk_attach" {
  for_each           = toset([for j in local.datadisk_lun_map : j.datadisk_name])
  managed_disk_id    = azurerm_managed_disk.managed_disk[each.key].id
  virtual_machine_id = azurerm_windows_virtual_machine.vm_winvm[element(split("_", each.key), 1)].id
  lun                = lookup(local.luns, each.key)
  caching            = "ReadWrite"
}
