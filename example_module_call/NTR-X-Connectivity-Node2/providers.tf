provider "azurerm" {
  features {}
}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.12.0"
    }
  }
  backend "azurerm" {
      resource_group_name   = "TerraformIACTest"
      storage_account_name  = "terraformiactest"
      container_name        = "statefiles"
      key                   = "terraform.tfstate"
      use_microsoft_graph   = true
  }
}
