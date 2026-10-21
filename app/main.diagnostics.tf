# The released spoke module has no diagnostics input, so the app root sends the
# landing-zone Key Vault, storage, VNet and NSG diagnostics to the app workspace.
data "azurerm_resources" "landingzone" {
  resource_group_name = var.networking.resource_group_name
}

locals {
  landingzone_diagnostic_types = [
    "microsoft.keyvault/vaults",
    "microsoft.network/networksecuritygroups",
    "microsoft.network/virtualnetworks",
    "microsoft.storage/storageaccounts",
  ]

  landingzone_diagnostic_resources = {
    for resource in data.azurerm_resources.landingzone.resources : resource.name => resource
    if contains(local.landingzone_diagnostic_types, lower(resource.type))
  }

  # Storage logs are collected on the blob service.
  landingzone_diagnostic_targets = merge(
    { for name, resource in local.landingzone_diagnostic_resources : name => resource.id },
    {
      for name, resource in local.landingzone_diagnostic_resources : "${name}-blob" => "${resource.id}/blobServices/default"
      if lower(resource.type) == "microsoft.storage/storageaccounts"
    }
  )
}

data "azurerm_monitor_diagnostic_categories" "landingzone" {
  for_each = local.landingzone_diagnostic_targets

  resource_id = each.value
}

resource "azurerm_monitor_diagnostic_setting" "landingzone" {
  for_each = local.landingzone_diagnostic_targets

  name                       = "log-analytics"
  target_resource_id         = each.value
  log_analytics_workspace_id = module.log_analytics_cluster.workspaces["app"].id

  dynamic "enabled_log" {
    for_each = contains(data.azurerm_monitor_diagnostic_categories.landingzone[each.key].log_category_groups, "allLogs") ? ["allLogs"] : []

    content {
      category_group = enabled_log.value
    }
  }

  dynamic "enabled_metric" {
    for_each = data.azurerm_monitor_diagnostic_categories.landingzone[each.key].metrics

    content {
      category = enabled_metric.value
    }
  }
}

