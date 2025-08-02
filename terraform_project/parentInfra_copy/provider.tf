terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.34.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "fadfa500-48fa-4d7d-ae72-215103d56b2f"
}

data "azurerm_client_config" "current" {}
