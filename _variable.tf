variable "project_name_prefix" {
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
  default     = "app-rg"
}

variable "location" {
  description = "The Azure region where the resources will be deployed. E.g., 'East US', 'West Europe', etc."
  type        = string
  default     = "EAST US 2"
}


variable "enable_vnet_integration" {
  type    = bool
  default = false
}

variable "create_resource_group" {
  type    = bool
  default = false
}

variable "subnet_id" {
  description = "The resource id of the subnet for vnet association"
  default     = null
}

variable "app_gateway_subnet_id" {
  description = "The resource id of the subnet for application gateway"
  default     = null
}

#####################################################################################################
####                            App Service                                                      ####
#####################################################################################################

variable "web_app_name" {
  type    = string
  default = "myApp000110"
}


variable "app_service_plan_name" {
  type    = string
  default = "myAppServicePlan"
}

variable "os_type" {
  type    = string
  default = "Linux"
}

variable "sku_name" {
  type    = string
  default = "P1v2"
}

variable "public_network_access_enabled" {
  type    = bool
  default = true
}


variable "site_config" {
  description = "site settings for App service"
  type = object({
    always_on                   = bool
    http2_enabled               = bool
    load_balancing_mode         = string
    managed_pipeline_mode       = string
    minimum_tls_version         = string
    remote_debugging_enabled    = bool
    scm_minimum_tls_version     = string
    scm_use_main_ip_restriction = bool
    vnet_route_all_enabled      = bool
    websockets_enabled          = optional(bool)
  })

  default = {
    always_on                   = true
    http2_enabled               = false
    load_balancing_mode         = "LeastRequests"
    managed_pipeline_mode       = "Integrated"
    minimum_tls_version         = "1.2"
    remote_debugging_enabled    = false
    scm_minimum_tls_version     = "1.2"
    scm_use_main_ip_restriction = false
    vnet_route_all_enabled      = false
    websockets_enabled          = false
  }
}

variable "cors" {
  description = "Cross-Origin Resource Sharing (CORS) settings"
  type = list(object({
    allowed_origins = list(string)
  }))
  default = [
    {
      allowed_origins = ["https://portal.azure.com"]
    }
  ]
}

variable "enable_auth_settings" {
  description = "Specifies the Authenication enabled or not"
  default     = false
}

variable "default_auth_provider" {
  description = "The default provider to use when multiple providers have been set up. Possible values are `AzureActiveDirectory`, `Facebook`, `Google`, `MicrosoftAccount` and `Twitter`"
  default     = "AzureActiveDirectory"
}

variable "unauthenticated_client_action" {
  description = "The action to take when an unauthenticated client attempts to access the app. Possible values are `AllowAnonymous` and `RedirectToLoginPage`"
  default     = "RedirectToLoginPage"
}

variable "token_store_enabled" {
  description = "If enabled the module will durably store platform-specific security tokens that are obtained during login flows"
  default     = false
}

variable "active_directory_auth_setttings" {
  description = "Acitve directory authentication provider settings for app service"
  type        = any
  default     = {}
}

variable "identity" {
  default = "SystemAssigned"

}

variable "https_only" {
  default = true
}

variable "connection_strings" {
  description = "Connection strings for App Service"
  default     = []
}

variable "app_settings" {
  description = "A key-value pair of App Settings."
  type        = map(string)
  default     = {}
}



#####################################################################################################
####                            Application Gateway                                              ####
#####################################################################################################

variable "create_application_gateway" {
  type    = bool
  default = false
}

variable "public_ip_name" {
  type    = string
  default = "app-gateway-public-ip"
}

variable "public_ip_sku" {
  type    = string
  default = "Standard"
}

variable "allocation_method" {
  type    = string
  default = "Static"
}

variable "app_gateway_name" {
  type    = string
  default = "app-service-gateway"
}

variable "app_gateway_sku_name" {
  type    = string
  default = "Standard_v2"
}

variable "app_gateway_sku_tier" {
  type    = string
  default = "Standard_v2"
}

variable "app_gateway_sku_capacity" {
  type    = number
  default = 2
}

variable "gateway_ip_configuration_name" {
  type    = string
  default = "my-gateway-ip-configuration"
}

variable "frontend_port" {
  type    = number
  default = 80
}

variable "cookie_based_affinity" {
  type    = string
  default = "Enabled"
}

variable "path" {
  type    = string
  default = "/"
}

variable "port" {
  type    = number
  default = 80
}

variable "protocol" {
  type    = string
  default = "Http"
}

variable "request_timeout" {
  type    = number
  default = 60
}

variable "http_listener_protocol" {
  type    = string
  default = "Http"
}

variable "request_routing_rule_type" {
  type    = string
  default = "Basic"
}

variable "probe_interval" {
  type    = number
  default = 30
}

variable "probe_timeout" {
  type    = number
  default = 120
}

variable "probe_unhealthy_threshold" {
  type    = number
  default = 3
}

variable "pick_host_name_from_backend_http_settings" {
  type    = bool
  default = true
}

variable "match_body" {
  type    = string
  default = "Welcome"

}

variable "match_status_code" {
  type    = list(number)
  default = [200, 399]
}

variable "pick_host_name_from_backend_address" {
  type    = bool
  default = true
}




#####################################################################################################
####                        Backup default is false                                              ####
#####################################################################################################

variable "enable_backup" {
  description = "bool to to setup backup for app service"
  default     = false
}


variable "backup_settings" {
  description = "Backup settings for App service"
  type = object({
    name                  = string
    enabled               = bool
    storage_account_url   = optional(string)
    frequency_interval    = number
    frequency_unit        = optional(string)
    retention_period_days = optional(number)
    start_time            = optional(string)
  })
  default = {
    enabled               = false
    name                  = "DefaultBackup"
    frequency_interval    = 1
    frequency_unit        = "Day"
    retention_period_days = 30
  }
}


variable "storage_mounts" {
  description = "Storage account mount points for App Service"
  type        = list(map(string))
  default     = []
}


#####################################################################################################
####                                 storage Account                                             ####
#####################################################################################################


variable "password_rotation_in_years" {
  description = "Number of years to add to the base timestamp to configure the password rotation timestamp. Conflicts with password_end_date and either one is specified and not the both"
  default     = 2
}


variable "storage_acc_resource_group_name" {
  description = "name of your existing resource group name where your storage account is"
  default     = "kjnvjnvne_group"
}

variable "storage_account_name" {
  description = "The name of the azure storage account"
  default     = "storageacc11"
}

variable "password_end_date" {
  description = "The relative duration or RFC3339 rotation timestamp after which the password expire"
  default     = null
}

variable "storage_container_name" {
  description = "The name of the storage container to keep backups"
  default     = null
}

variable "container_access_type" {
  description = "access type for container"
  default     = "private"
}

variable "permissions" {
  description = "permissions for SAS token"
  type = object({
    read   = bool
    add    = bool
    create = bool
    write  = bool
    delete = bool
    list   = bool
  })

  default = {
    read   = true
    add    = true
    create = true
    write  = true
    delete = true
    list   = true

  }
}


variable "blob_container_sas" {
  description = "content encoding,language and type for SAS token"
  default = {
    cache_control       = "max-age=5"
    content_disposition = "inline"
    content_encoding    = "deflate"
    content_language    = "en-US"
    content_type        = "application/json"
  }
}







#####################################################################################################
####                            Application Insights                                             ####
#####################################################################################################

variable "application_insights_enabled" {
  description = "Specify the Application Insights use for this App Service"
  default     = false
}

variable "application_insights_id" {
  description = "Resource ID of the existing Application Insights"
  default     = null
}

variable "app_insights_name" {
  description = "The Name of the application insights"
  default     = ""
}

variable "application_insights_type" {
  description = "Specifies the type of Application Insights to create. Valid values are `ios` for iOS, `java` for Java web, `MobileCenter` for App Center, `Node.JS` for Node.js, `other` for General, `phone` for Windows Phone, `store` for Windows Store and `web` for ASP.NET."
  default     = "web"
}

variable "retention_in_days" {
  description = "Specifies the retention period in days. Possible values are `30`, `60`, `90`, `120`, `180`, `270`, `365`, `550` or `730`"
  default     = 90
}

variable "disable_ip_masking" {
  description = "By default the real client ip is masked as `0.0.0.0` in the logs. Use this argument to disable masking and log the real client ip"
  default     = false
}

