terraform {
  backend "azurerm" {
    resource_group_name  = "<THIS WILL BE REPLACED VIA -backend-config>"
    storage_account_name = "<THIS WILL BE REPLACED VIA -backend-config>"
    container_name       = "tfstate"
    key                  = "mydemo.tfstate"
  }
}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.46.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "rg-demo-synapse-example-resources"
  location = var.location
}

