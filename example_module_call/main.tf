module "code_src" {
    source  = "git::https://github.com/S7evenCalevra/Terraform_Modules.git"
}

module "windows_vm" {
    
    source =   "./.terraform/modules/code_src/modules/WindowsVM"
    
    #source = "../../../modules/windows_vm"
    environment = "Dev"
    resource_group = "testdeploy-dev-resource-group"
    vm_network = "testdeploy-dev-network"
    vm_network_subnet = "internal"
    vm_machine_name = "WinTestVM"
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
