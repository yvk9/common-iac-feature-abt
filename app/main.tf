module "resource_group" {
  source = "git::https://azdo.fdcctx.us/EFTPS/Modernization/_git/terraform-azurerm-resource_group?ref=v1.0.0"

  name                   = "${var.workload_name}-app-${local.regions_map[var.location]}-${var.env_abv}"
  workload_name          = var.workload_name
  environment            = var.environment
  application            = var.application
  location               = var.location
  env_abv                = var.env_abv
  application_service_id = var.application_service_id

}

