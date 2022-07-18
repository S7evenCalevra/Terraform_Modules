module "code_src" {
    source  = "git::https://github.com/S7evenCalevra/Terraform_Modules.git"
}

module "windows_vm" {
    
    source =   "./.terraform/modules/code_src/modules/WindowsVM"
    
    #source = "../../../modules/windows_vm"
    environment = "Dev"
    resource_group = "rg-cm-nice_servers-dev-us2"
    vm_names = ["NTR-X-Datastore-Manager-Node1", "NTR-X-Datastore-Manager-Node2"]
    vm_size = "standard_F16"
    nb_disks_per_vm = 2
    nb_nics_per_vm = 2
    vm_os_disk_size = 127
    vm_data_disk_size_1 = 20
}
