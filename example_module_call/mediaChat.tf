module "code_src" {
    source  = "git::https://github.com/S7evenCalevra/Terraform_Modules.git"
}

module "windows_vm" {
    
    source =   "./.terraform/modules/code_src/modules/WindowsVM"
    
    #source = "../../../modules/windows_vm"
    environment = "Dev"
    resource_group = "rg-cm-nice_servers-dev-us2"
    vm_machine_name = "Microsoft-Teams-Media-Chat1"
    vm_names = ["mediaChat1", "mediaChat2","mediaChat3","mediaChat4", 			"mediaChat5", "mediaChat6", "mediaChat7", "mediaChat9"]
    
    vm_size = "Standard_F16"
    nb_disks_per_vm = 2
    nb_nics_per_vm = 2
    vm_os_disk_size = 127
    vm_data_disk_size_1 = 20
}
