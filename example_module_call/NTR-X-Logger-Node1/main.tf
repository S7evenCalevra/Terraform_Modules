module "code_src" {
    source  = "git::https://github.com/S7evenCalevra/Terraform_Modules.git"
}

module "windows_vm" {
    
    source =   "./.terraform/modules/code_src/modules/WindowsVM"
    
    #source = "../../../modules/windows_vm"
    environment = "Dev"
    resource_group = "testdeploy-dev-resource-group"
    vm_machine_name = "NTR-X-DSM1"
    vm_names = ["vm-test-1", "vm-test-3"]
    vm_size = "Standard_D13"
    nb_disks_per_vm = 2
    nb_nics_per_vm = 2
    vm_os_disk_size = 127
    vm_data_disk_size_1 = 20
    vm_count = 2
}
