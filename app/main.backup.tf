module "backup_vault" {
  source = "git::https://azdo.fdcctx.us/EFTPS/Modernization/_git/terraform-azurerm-backup_vault?ref=v1.0.0"

  workload_name          = var.workload_name
  resource_group_name    = module.resource_group.name
  location               = var.location
  environment            = var.environment
  application            = var.application
  application_service_id = var.application_service_id

  blob_backup_policies = {
    blob = {
      operational_default_retention_duration = "P30D"
    }
  }

  diagnostic_settings = {
    log-analytics = {
      log_analytics_workspace_id = module.log_analytics_cluster.workspaces["app"].id
    }
  }
}

