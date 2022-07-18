variable "environment" {
    type = string
    description = "Environment to Deploy to: Dev/QA/Prod"
}

variable "resource_group" {
    type = string
    description = "Name of the resource group this server should be created in"
}

variable "vm_network" {
    type = string
    default = "vnet-cm-nice_servers-dev-use2"
    description = "Name of the virtual network the vm connects to"
}

variable "vm_network_subnet" {
    type = string
    default = "default"
    description = "Name of the subnet in the VM network"
}

variable "vm_names" {
    type = list
    
}

variable "nb_disks_per_vm" {
    type = number
}

variable "nb_nics_per_vm" {
    type = number
}


variable "vm_size" {
    type = string
    description = "Size tempalate for the VM to use.  For example: Standard_F2"
}

# variable "vm_network_interface_count" {
#     type = number
#     description = "Number of network interfaces for the VM"
# }

variable "vm_os_disk_size" {
    type = string
    description = "Size in GB for OS Disk"
}

variable "vm_data_disk_size_1" {
    type = number
    description = "Size in GB for Data disk 1"
}

# variable "vm_data_disk_size_2" {
#     type = number
#     description = "Size in GB for Data disk 2"
# }

# variable "vm_data_disk_size_3" {
#     type = number
#     description = "Size in GB for Data disk 3"
# }

variable "keyvault_rg" {
  type = string
  default = "TerraformIACTest"
  description = "keyvault_rg"
}

variable "keyvault_name" {
  type = string
  default = "terraffirniac-kv"
  description = "keyvault_name"
}

variable "keyvault_token" {
  type = string
  default = "testVMToken"
  description = "keyvault_token"
}

variable "vm_count" {
  default = 1
  description = "number of virtual machines to create"
}
