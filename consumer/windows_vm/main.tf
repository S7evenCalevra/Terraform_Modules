provider "azurerm" {
    features{}
}

module "code_src" {
    source              = "git::https://github.com/S7evenCalevra/Terraform_Modules/tree/main/modules"
}

module "test_windows_vm" {
    source =   "./.terraform/modules/code_src/modules/windows_vm"
    #source = "../../../modules/windows_vm"
    environment = "Dev"
    resource_group = "testdeploy-dev-resource-group"
    vm_network = "testdeploy-dev-network"
    vm_network_subnet = "internal"
    vm_machine_name = "CMtestVM"
    vm_size = "Standard_B2s"
    vm_network_interface_count = "2"
    vm_os_disk_size = 127
    vm_data_disk_size_1 = 20
    vm_data_disk_size_2 = 15
    vm_data_disk_size_3 = 10
    keyvault_rg = "TerraformIACTest"
    keyvault_name = "terraffirniac-kv"
    keyvault_token = "testVMToken"
}

module "test_windows_vm2" {
    source  = "./.terraform/modules/code_src/modules/windows_vm"
    #source = "../../../modules/windows_vm"
    resource_group = "testdeploy-dev-resource-group"
    environment = "Dev"
    vm_network = "testdeploy-dev-network"
    vm_network_subnet = "internal"
    vm_machine_name = "CMtestVM2"
    vm_size = "Standard_B2s"
    vm_network_interface_count = "3"
    vm_os_disk_size = 127
    vm_data_disk_size_1 = 15
    vm_data_disk_size_2 = 15
    vm_data_disk_size_3 = 10
    keyvault_rg = "TerraformIACTest"
    keyvault_name = "terraffirniac-kv"
    keyvault_token = "testVMToken"
}
