# normal subnet with service endpoints
# create subnet
resource "azurerm_subnet" "testsubnet1" {
  name                  = var.name
  resource_group_name   = var.rg_name
  virtual_network_name  = var.vnet_name
  address_prefixes      = var.address_prefixes

  service_endpoints = var.service_endpoints

  enforce_private_link_endpoint_network_policies = true
  enforce_private_link_service_network_policies = false
}

# output variables
output "subnet_id" {
  value = azurerm_subnet.this.id
}

# delegated subnet, needed for integration with App Service
# create subnet
resource "azurerm_subnet" "testsubnet1" {
  name                  = var.name
  resource_group_name   = var.rg_name
  virtual_network_name  = var.vnet_name
  address_prefixes      = var.address_prefixes

  service_endpoints = var.service_endpoints
  
  delegation {
    name = var.delegation_name
    service_delegation {
      name = var.service_delegation
      actions = var.delegation_actions
    }
  }

  enforce_private_link_endpoint_network_policies = false
  enforce_private_link_service_network_policies = false
}

# output variables
output "subnet_id" {
  value = azurerm_subnet.this.id
}
