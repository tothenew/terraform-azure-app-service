variable "name_prefix" {
  description = "Used in tags cluster and nodes"
  type        = string
  default     = "dev"
}

variable "default_tags" {
  type        = map(string)
  description = "A map to add common tags to all the resources"
  default = {
    "Scope" : "database"
    "CreatedBy" : "Terraform"
  }
}

variable "common_tags" {
  type        = map(string)
  description = "A map to add common tags to all the resources"
  default = {
    Project    = "Azure_database",
    Managed-By = "TTN",
  }
}

variable "resource_group_name" {
  description = "The name of the Azure Resource Group where the resources will be created."
  type        = string
}

variable "location" {
  description = "The Azure region where the resources will be deployed. E.g., 'East US', 'West Europe', etc."
  type        = string
}

variable "vnet_name" {
  description = "name of the virtual network"
  type = string
}

variable "vnetcidr" {
    description = "The CIDR block for the virtual network (VNet)."
    type        = string
}

variable "app_gateway_subnet_name" {
  description = "Name of the subnet for the application gateway"
  type = string
  default = "my-app-gateway-subnet"
}

variable "app_service_subnet_name" {
  description = "Name of the subnet for the app service"
  type = string
  default = "my-app-service-subnet"
}

variable "db_subnet_name" {
  description = "Name of the subnet for the database"
  type = string
  default = "my-db-subnet"
}

variable "app_gateway_address_prefixe" {
  description = "The list of address prefixes to be used for defining the IP address range for the subnet."
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

variable "app_service_address_prefixe" {
  description = "The list of address prefixes to be used for defining the IP address range for the subnet."
  type        = list(string)
  default     = ["10.0.2.0/24"]
}

variable "db_subnet_address_prefixe" {
  description = "The list of address prefixes to be used for defining the IP address range for the subnet."
  type        = list(string)
  default     = ["10.0.3.0/24"]
}

variable "app_gateway_subnet_service_endpoint" {
  description = "List of service endpoints for the application gateway subnet"
  type = list(string)
  default = ["Microsoft.Web"]
}

variable "app_subnet_delegation_name" {
  description = "Name of delegation for the app service subnet"
  type = string
  default = "delegation"
}

variable "app_subnet_service_delegation_actions" {
  description = "List of delegation actions for the app service subnet"
  type = list(string)
  default = [
            "Microsoft.Network/virtualNetworks/subnets/action",
            "Microsoft.Network/virtualNetworks/subnets/join/action"
          ]
}

variable "app_subnet_service_delegation_name" {
  description = "Name of service delegation for the app service subnet"
  type = string
  default = "Microsoft.Web/serverFarms"
}

variable "db_subnet_service_endpoint" {
  description = "List of service endpoints for the database subnet"
  type = list(string)
  default = ["Microsoft.Storage"]
}

variable "db_subnet_delegation_name" {
  description = "Name of delegation for the database subnet"
  type = string
  default = "fs"
}

variable "db_subnet_service_delegation_actions" {
  description = "List of delegation actions for the database subnet"
  type = list(string)
  default = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
}

variable "db_subnet_service_delegation_name" {
  description = "Name of service delegation for the database subnet"
  type = string
  default = "Microsoft.DBforMySQL/flexibleServers"
}



#################################################################################
variable "linux_web_app_name" {
  description = "Name of the Linux web app"
  type    = string
  default = "myApp000110"
}

variable "app_service_plan_name" {
  description = "Name of the Azure App Service Plan"
  type = string
  default = "myAppServicePlan"
}

variable "os_type" {
  description = "Operating system type of the web app"
  type = string
  default ="Linux"
}

variable "sku_name" {
  description = "SKU name of the App Service Plan"
  type = string
  default = "P1v2"
}

variable "public_network_access_enabled" {
  description = "Flag to enable public network access for the web app"
  type    = bool
  default = true
}

variable "ip_restriction_action" {
  description = "Action for IP restriction rule"
  type = string
  default = "Allow"
}

variable "ip_restriction_priority" {
  description = "Priority for IP restriction rule"
  type = number
  default = 200
}


variable "always_on" {
  description = "Flag to keep the web app always on"
  type    = bool
  default = true
}

variable "container_registry_use_managed_identity" {
  description = "Flag to use managed identity for container registry"
  type = bool
  default = false
}

variable "load_balancing_mode" {
  description = "Load balancing mode for the web app"
  type = string
  default = "LeastRequests"
}

variable "account_tier" {
  description = "Storage account tier"
  type = string
  default = "Standard"
}

variable "account_replication_type" {
  description = "Storage account replication type"
  type = string
  default = "GRS"
}

#######################################################

variable "public_ip_name" {
  description = "Name of the public IP address for the application gateway"
  type = string
  default = "app-gateway-public-ip"
}

variable "public_ip_sku" {
  description = "SKU of the public IP address for the application gateway"
  type = string
  default = "Standard"
}

variable "allocation_method" {
  type = string
  default = "Static"
}

variable "app_gateway_name" {
  description = "Allocation method for the public IP address"
  type = string
  default = "app-service-gateway"
}

variable "app_gateway_sku_name" {
  description = "SkU Name of the Azure Application Gateway"
  type = string
  default = "Standard_v2"
}

variable "app_gateway_sku_tier" {
  description = "The tier of the application gateway SKU"
  type = string
  default = "Standard_v2"
}

variable "app_gateway_sku_capacity" {
  description = "The capacity of the application gateway SKU"
  type = number
  default = 2
}

variable "gateway_ip_configuration_name" {
    description = "Name of the gateway IP configuration for the application gateway"
    type = string
    default = "my-gateway-ip-configuration"
}

variable "frontend_port" {
  description = "Port used by the frontend configuration of the application gateway"
  type = number
  default = 80
}

variable "cookie_based_affinity" {
  description = "Setting for cookie-based affinity in the application gateway"
  type = string
  default = "Enabled"
}

variable "path" {
  description = "The path to use in the backend HTTP settings"
  type = string
  default = "/"
}

variable "port" {
  description = "Port used in the backend HTTP settings"
  type = number
  default = 80
}

variable "protocol" {
  description = "Protocol used in the backend HTTP settings"
  type = string
  default = "Http"
}

variable "request_timeout" {
  description = "Timeout for requests in the backend HTTP settings"
  type = number
  default = 60
}

variable "http_listener_protocol" {
  description = "Protocol used by the HTTP listener"
  type = string
  default = "Http"
}

variable "request_routing_rule_type" {
  description = "Type of request routing rule in the application gateway"
  type = string
  default = "Basic"
}

variable "probe_interval" {
  description = "Interval between probes in seconds"
  type = number
  default = 30
}

variable "probe_timeout" {
  description = "Timeout for probes in seconds"
  type = number
  default = 120
}

variable "probe_unhealthy_threshold" {
  description = "Threshold for unhealthy probes"
  type = number
  default = 3
}

variable "pick_host_name_from_backend_http_settings" {
  description = "Flag to indicate whether to pick the host name from backend HTTP settings"
  type = bool
  default = true
}

variable "match_body" {
  description = "Expected response body content for the probe match"
  type = string
  default = "Welcome"
  
}

variable "match_status_code" {
  description = "List of status codes to match for the probe"
  type = list(number)
  default = [200, 399]
 }

variable "pick_host_name_from_backend_address" {
  description = "Flag to indicate whether to pick the host name from backend address"
  type = bool
  default = true
}