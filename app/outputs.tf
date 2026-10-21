output "resource_group_name" {
  description = "App resource group name."
  value       = module.resource_group.name
}

output "key_vault_id" {
  description = "App Key Vault ID."
  value       = module.key_vault.id
}

output "log_analytics_cluster_id" {
  description = "Log Analytics cluster ID."
  value       = module.log_analytics_cluster.id
}

output "log_analytics_workspace_id" {
  description = "App Log Analytics workspace ID."
  value       = module.log_analytics_cluster.workspaces["app"].id
}

output "backup_vault_id" {
  description = "Backup vault ID."
  value       = module.backup_vault.id
}

output "blob_backup_policy" {
  description = "Blob backup policy ID and name."
  value       = module.backup_vault.backup_policies.blob["blob"]
}

output "apim_workspace_id" {
  description = "APIM workspace ID, or null when the environment has no workspace."
  value       = try(module.apim_workspace[0].id, null)
}
