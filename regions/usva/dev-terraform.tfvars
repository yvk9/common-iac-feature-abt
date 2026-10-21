# Domain information
workload_name          = "app-c"
application            = "Common"
environment            = "dev"
env_abv                = "dev"
application_service_id = "SNSVC0042142"
location               = "usgovvirginia"

# Provider information
subscription_id = "08399702-bcfc-45e0-b079-698dc8f1d80c" # sub-app-c-dev

connectivity = {
  subscription_id     = "a06b5ac9-74c0-4307-96eb-ccfa5d801517"
  resource_group_name = "fdccctx-vwan-usgovvirginia-prod"
  hubs = {
    usva = {
      name = "fdcctx-hub-usgovvirginia"
    }
    usaz = {
      name = "fdcctx-hub-usgovarizona"
    }
  }
}

management = {
  subscription_id         = "e0e6c71a-aeda-4594-a3ee-272a81cf9510"
  dns_resource_group_name = "fdcctx-rg-dns-prod"
  private_dns_zones = {
    vaultcore = "privatelink.vaultcore.usgovcloudapi.net"
    blob      = "privatelink.blob.core.usgovcloudapi.net"
  }
}

# Spoke information
spoke = {
  address_space = ["10.247.148.0/24"]
  private_endpoint_subnet = {
    name             = "snet-app-c-pep-usva-dev"
    address_prefixes = ["10.247.148.64/26"]
    route_table = {
      routes = {
        default = {
          address_prefix         = "0.0.0.0/0"
          next_hop_type          = "VirtualAppliance"
          next_hop_in_ip_address = "10.247.0.132"
        }
      }
    }
  }
  subnets = {
    gw = {
      name                              = "snet-app-c-gw-usva-dev"
      address_prefixes                  = ["10.247.148.0/28"]
      default_outbound_access_enabled   = false
      private_endpoint_network_policies = "Enabled"
      route_table = {
        routes = {
          default = {
            address_prefix         = "0.0.0.0/0"
            next_hop_type          = "VirtualAppliance"
            next_hop_in_ip_address = "10.247.0.132"
          }
        }
      }
    }
    apim = {
      name                              = "snet-app-c-apim-usva-dev"
      address_prefixes                  = ["10.247.148.16/28"]
      default_outbound_access_enabled   = false
      private_endpoint_network_policies = "Enabled"
      route_table = {
        routes = {
          default = {
            address_prefix         = "0.0.0.0/0"
            next_hop_type          = "VirtualAppliance"
            next_hop_in_ip_address = "10.247.0.132"
          }
        }
      }
    }
    app = {
      name                              = "snet-app-c-app-usva-dev"
      address_prefixes                  = ["10.247.148.128/25"]
      default_outbound_access_enabled   = false
      private_endpoint_network_policies = "Enabled"
      route_table = {
        routes = {
          default = {
            address_prefix         = "0.0.0.0/0"
            next_hop_type          = "VirtualAppliance"
            next_hop_in_ip_address = "10.247.0.132"
          }
        }
      }
    }
  }
}

# App information
networking = {
  subnets = {
    pep = "snet-app-c-pep-usva-dev"
  }
  virtual_network_name = "vnet-app-c-usva-dev"
  resource_group_name  = "rg-app-c-ntwk-usva-dev"
}

# API Management
api_management_id = "/subscriptions/cafec406-ad7d-4056-a52c-4ba62db04f0e/resourceGroups/rg-app-o-usva-dev/providers/Microsoft.ApiManagement/service/apim-app-o-usva-dev"

