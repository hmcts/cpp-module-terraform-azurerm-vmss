terraform {
  required_version = ">= 0.12.20"
}

provider "azurerm" {
  version = "~>2.65.0"
  features {}
}