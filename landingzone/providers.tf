provider "azurerm" {
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
  environment     = var.azure_environment

  features {
    api_management {
      purge_soft_delete_on_destroy = true
      recover_soft_deleted         = true
    }
    cognitive_account {
      purge_soft_delete_on_destroy = true
    }
  }
}

provider "azurerm" {
  alias           = "connectivity"
  subscription_id = var.connectivity.subscription_id
  tenant_id       = var.tenant_id
  environment     = var.azure_environment

  features {}
}

provider "azurerm" {
  alias           = "management"
  subscription_id = var.management.subscription_id
  tenant_id       = var.tenant_id
  environment     = var.azure_environment

  features {}
}

