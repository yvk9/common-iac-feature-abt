module "apim_workspace" {
  providers = {
    azurerm = azurerm.apim
  }
  source = "git::https://azdo.fdcctx.us/EFTPS/Modernization/_git/terraform-azurerm-apim_workspace?ref=091c04c26c51b3e7f12578045b5b3635fb6175cf"
  count  = var.api_management_id == null ? 0 : 1

  name              = "${lower(var.application)}-${var.environment}"
  api_management_id = var.api_management_id
  display_name      = "${var.application} ${upper(var.environment)}"
  description       = "${var.application} ${upper(var.environment)} workspace"
}

