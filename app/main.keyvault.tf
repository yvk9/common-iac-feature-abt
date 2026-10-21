module "key_vault" {
  source = "git::https://azdo.fdcctx.us/EFTPS/Modernization/_git/terraform-azurerm-key_vault?ref=v1.0.1"

  workload_name          = "${var.workload_name}-app"
  resource_group_name    = module.resource_group.name
  location               = var.location
  environment            = var.environment
  application            = var.application
  application_service_id = var.application_service_id

  sku_name                 = "premium"
  purge_protection_enabled = true

  network_acls = {
    default_action = "Deny"
    bypass         = "AzureServices"
  }

  private_endpoints = {
    vault = {
      subnet_id            = data.azurerm_subnet.pep.id
      private_dns_zone_ids = [data.azurerm_private_dns_zone.this["vaultcore"].id]
    }
  }

  role_assignments = merge(
    {
      deployer-crypto-officer = {
        principal_id         = data.azurerm_client_config.current.object_id
        role_definition_name = "Key Vault Crypto Officer"
      }
    },
    local.cluster_role_assignments
  )

  keys = {
    "log-analytics-cluster-cmk" = {
      key_type = "RSA-HSM"
      key_size = 3072
      key_opts = ["unwrapKey", "wrapKey"]
      rotation_policy = {
        expire_after         = "P1Y"
        notify_before_expiry = "P30D"
        automatic = {
          time_before_expiry = "P30D"
        }
      }
    }
  }
}

# The released Key Vault module has no diagnostics input.
resource "azurerm_monitor_diagnostic_setting" "key_vault" {
  name                       = "log-analytics"
  target_resource_id         = module.key_vault.id
  log_analytics_workspace_id = module.log_analytics_cluster.workspaces["app"].id

  enabled_log {
    category_group = "allLogs"
  }

  enabled_metric {
    category = "AllMetrics"
  }
}

