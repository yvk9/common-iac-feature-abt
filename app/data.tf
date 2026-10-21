data "azurerm_client_config" "current" {}

data "azurerm_subnet" "pep" {
  name                 = var.networking.subnets.pep
  resource_group_name  = var.networking.resource_group_name
  virtual_network_name = var.networking.virtual_network_name
}

data "azurerm_private_dns_zone" "this" {
  provider = azurerm.management
  for_each = var.management.private_dns_zones

  name                = each.value
  resource_group_name = var.management.dns_resource_group_name
}

