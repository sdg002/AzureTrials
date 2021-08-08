terraform {
  backend "azurerm" {
    resource_group_name  = "rg-demo-terraform-simple-storage-container"
    storage_account_name = "mydemotfstoragestate"
    container_name       = "tfstate"
    key                  = "mydemo.tfstate"

    # rather than defining this inline, the Access Key can also be sourced
    # from an Environment Variable - more information is available below.
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

#
#Your custom resources come below
#
resource "azurerm_resource_group" "demoresourcegroup" {
  name     = var.demoresourcegroup
  location = var.location
}

resource "azurerm_storage_account" "example" {
  name                     = "mydemoaccountname"
  resource_group_name      =  azurerm_resource_group.demoresourcegroup.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags = {
    key1 = "value1"
  }
}
