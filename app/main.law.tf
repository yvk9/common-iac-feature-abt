locals {
  cluster_role_assignments = {
    cluster-crypto-service-encryption-user = {
      principal_id                     = module.log_analytics_cluster.principal_id
      role_definition_name             = "Key Vault Crypto Service Encryption User"
      principal_type                   = "ServicePrincipal"
      skip_service_principal_aad_check = true
      description                      = "Log Analytics cluster customer managed key"
      key_key                          = "log-analytics-cluster-cmk"
    }
  }
}
module "log_analytics_cluster" {
  providers = {
    azurerm            = azurerm
    azurerm.management = azurerm.management
  }
  source = "git::https://azdo.fdcctx.us/EFTPS/Modernization/_git/terraform-azurerm-log_analytics_cluster?ref=v1.0.1"

  workload_name       = var.workload_name
  location            = var.location
  resource_group_name = module.resource_group.name

  identity = {
    type = "SystemAssigned"
  }

  customer_managed_key = {
    key_vault_key_id = (
      module.key_vault.role_assignment_ids["cluster-crypto-service-encryption-user"] != null
      ? module.key_vault.keys["log-analytics-cluster-cmk"].versionless_id
      : null
    )
    grant_key_vault_role = false
  }

  workspaces = {
    app = {
      retention_in_days = 365

      identity = {
        type = "SystemAssigned"
      }

      tables = {
        AppAvailabilityResults = {
          total_retention_in_days = 2556
          retention_in_days       = 365
        }
        AppBrowserTimings = {
          total_retention_in_days = 2556
          retention_in_days       = 365
        }
        AppDependencies = {
          total_retention_in_days = 2556
          retention_in_days       = 365
        }
        AppEvents = {
          total_retention_in_days = 2556
          retention_in_days       = 365
        }
        AppExceptions = {
          total_retention_in_days = 2556
          retention_in_days       = 365
        }
        AppPerformanceCounters = {
          total_retention_in_days = 2556
          retention_in_days       = 365
        }
        AppMetrics = {
          total_retention_in_days = 2556
          retention_in_days       = 365
        }
        AppRequests = {
          total_retention_in_days = 2556
          retention_in_days       = 365
        }
        AppTraces = {
          total_retention_in_days = 2556
          retention_in_days       = 365
        }
      }
    }
  }

  environment            = var.environment
  application            = var.application
  application_service_id = var.application_service_id
}

