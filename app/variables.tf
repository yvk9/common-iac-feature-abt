variable "workload_name" {
  description = "Assigned workload code used in resource names."
  type        = string

  validation {
    condition     = var.workload_name != null
    error_message = "workload_name is pending: assigned when the subscription is vended."
  }

  validation {
    condition     = var.workload_name == null ? true : can(regex("^[a-z][a-z0-9-]*[a-z0-9]$", var.workload_name))
    error_message = "workload_name must use lowercase letters, digits and hyphens."
  }
}

variable "application" {
  description = "Application name for governance tags."
  type        = string
}

variable "application_service_id" {
  description = "Assigned application service ID for governance tags."
  type        = string

  validation {
    condition     = var.application_service_id == null ? false : length(trimspace(var.application_service_id)) > 0
    error_message = "application_service_id is pending: obtain the application service ID before deployment."
  }
}

variable "environment" {
  description = "Deployment environment code."
  type        = string

  validation {
    condition     = contains(["dev", "int", "lod", "prd"], var.environment)
    error_message = "environment must be dev, int, lod or prd."
  }
}

variable "env_abv" {
  description = "Environment suffix for resource names."
  type        = string

  validation {
    condition     = contains(["dev", "int", "lod", "prd"], var.env_abv) && var.env_abv == var.environment
    error_message = "env_abv must match environment: dev, int, lod or prd."
  }
}

variable "location" {
  description = "Azure Government deployment region."
  type        = string

  validation {
    condition     = contains(["usgovvirginia", "usgovarizona"], var.location)
    error_message = "location must be usgovvirginia or usgovarizona."
  }
}

variable "tenant_id" {
  description = "Deployment tenant ID."
  type        = string
  default     = "63761141-fb93-4151-b3bd-97196c9aafe6"
}

variable "azure_environment" {
  description = "Azure cloud used by the providers."
  type        = string
  default     = "usgovernment"

  validation {
    condition     = var.azure_environment == "usgovernment"
    error_message = "azure_environment must be usgovernment."
  }
}

variable "subscription_id" {
  description = "Vended workload subscription ID."
  type        = string

  validation {
    condition     = var.subscription_id != null
    error_message = "subscription_id is pending: complete subscription vending and the service connection before deployment."
  }

  validation {
    condition     = var.subscription_id == null ? true : can(regex("^[0-9a-fA-F]{8}-([0-9a-fA-F]{4}-){3}[0-9a-fA-F]{12}$", var.subscription_id))
    error_message = "subscription_id must be a subscription GUID."
  }
}

variable "connectivity" {
  description = "Shared connectivity subscription and regional hubs."
  type = object({
    subscription_id     = string
    resource_group_name = string
    hubs                = map(object({ name = string }))
  })

  validation {
    condition     = can(regex("^[0-9a-fA-F]{8}-([0-9a-fA-F]{4}-){3}[0-9a-fA-F]{12}$", var.connectivity.subscription_id))
    error_message = "connectivity.subscription_id must be a subscription GUID."
  }
}

variable "management" {
  description = "Shared management subscription and private DNS zones."
  type = object({
    subscription_id         = string
    dns_resource_group_name = string
    private_dns_zones       = map(string)
  })

  validation {
    condition     = can(regex("^[0-9a-fA-F]{8}-([0-9a-fA-F]{4}-){3}[0-9a-fA-F]{12}$", var.management.subscription_id))
    error_message = "management.subscription_id must be a subscription GUID."
  }

  # The app Key Vault endpoint uses this zone; the spoke module looks up its own zones.
  validation {
    condition     = contains(keys(var.management.private_dns_zones), "vaultcore")
    error_message = "management.private_dns_zones must contain vaultcore."
  }
}

variable "spoke" {
  description = "Spoke address space and subnets passed to the spoke network composition."
  type        = any

  validation {
    condition     = try(length(var.spoke.address_space) > 0 && alltrue([for cidr in var.spoke.address_space : can(cidrhost(cidr, 0))]), false)
    error_message = "spoke.address_space is pending: enter the IPAM allocation before deployment."
  }

  validation {
    condition = try(alltrue([
      for prefixes in concat([var.spoke.private_endpoint_subnet.address_prefixes], [for subnet in values(var.spoke.subnets) : subnet.address_prefixes]) :
      length(prefixes) > 0 && alltrue([for cidr in prefixes : can(cidrhost(cidr, 0))])
    ]), false)
    error_message = "spoke subnet prefixes are pending: enter the IPAM-approved subnet layout before deployment."
  }

  validation {
    condition = try(alltrue([
      for name in concat([var.spoke.private_endpoint_subnet.name], [for subnet in values(var.spoke.subnets) : subnet.name]) :
      length(trimspace(name)) > 0
    ]), false)
    error_message = "spoke subnet names are pending: fill the team names after the workload code is assigned."
  }
}

variable "networking" {
  description = "Landing-zone resource names read by the app root."
  type = object({
    resource_group_name  = string
    virtual_network_name = string
    subnets              = object({ pep = string })
  })

  validation {
    condition = alltrue([
      for name in [var.networking.resource_group_name, var.networking.virtual_network_name, var.networking.subnets.pep] :
      name == null ? false : length(trimspace(name)) > 0
    ])
    error_message = "networking names are pending: fill the deployed landing-zone names after the workload code is assigned."
  }
}

variable "api_management_id" {
  description = "API Management service that hosts the environment's workspace. Null creates no workspace."
  type        = string
  default     = null

  validation {
    condition     = var.api_management_id == null ? true : can(regex("^/subscriptions/[0-9a-fA-F-]{36}/resourceGroups/[^/]+/providers/Microsoft\\.ApiManagement/service/[^/]+$", var.api_management_id))
    error_message = "api_management_id must be an API Management service resource ID."
  }
}

