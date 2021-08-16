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

resource "azurerm_storage_account" "example" {
  name                     = "examplestorageac123"  #Change the storage if there is a collision
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  is_hns_enabled           = "true"
}

resource "azurerm_storage_data_lake_gen2_filesystem" "example" {
  name               = "example123"
  storage_account_id = azurerm_storage_account.example.id
}
