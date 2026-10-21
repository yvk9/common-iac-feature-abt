module "spoke_network" {
  source = "git::https://azdo.fdcctx.us/EFTPS/Modernization/_git/terraform-azurerm-spoke_network_composition?ref=v1.0.1"

  providers = {
    azurerm.connectivity = azurerm.connectivity
    azurerm.management   = azurerm.management
  }

  workload_name          = var.workload_name
  resource_group_name    = module.resource_group.name
  location               = var.location
  environment            = var.environment
  application            = var.application
  application_service_id = var.application_service_id

  address_space           = var.spoke.address_space
  private_endpoint_subnet = var.spoke.private_endpoint_subnet
  subnets                 = var.spoke.subnets
  virtual_hub             = {}

  key_vault = {
    sku_name               = "premium"
    network_default_action = "Deny"
  }

  storage_account = {
    public_network_access_enabled = false
    replication_type              = "GRS"
    private_endpoint_subresources = ["blob"]
  }
}

