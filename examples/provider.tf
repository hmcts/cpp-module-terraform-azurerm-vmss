terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.103"
    }
  }
}

provider "azurerm" {
  features {}
}
