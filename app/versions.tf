terraform {
  required_version = "~> 1.14"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.79"
    }
  }

  backend "azurerm" {
    use_azuread_auth = true
  }
}

