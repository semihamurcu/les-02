terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.27.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "c064671c-8f74-4fec-b088-b53c568245eb"
}
