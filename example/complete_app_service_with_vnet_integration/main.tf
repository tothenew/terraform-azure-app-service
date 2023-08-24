provider "azurerm" {
  features {}
}

## Users can create the resource group here 
resource "azurerm_resource_group" "main" {
  name     = "my-vnet-rg"
  location = "eastus"
}

module "vnet_main" {
  source = "git::https://github.com/tothenew/terraform-azure-vnet.git"

  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  address_space = "10.0.0.0/16"
  subnets = {
    "app_subnet" = {
      address_prefixes           = ["10.0.1.0/24"]
      associate_with_route_table = false
      is_natgateway              = false
      is_nsg                     = false
      service_delegation         = true
      delegation_name            = "Microsoft.Web/serverFarms"
      delegation_actions         = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}


module "Azure_App_Service" {
  source = "git::https://github.com/tothenew/terraform-azure-app-service.git"

  resource_group_name = "app-service-rg"
  location            = "EAST US 2"

  os_type  = "Linux"
  sku_name = "B2"

  web_app_name                  = "myApp000110"
  public_network_access_enabled = true

  site_config = {
    always_on                   = true
    http2_enabled               = false
    load_balancing_mode         = "LeastRequests"
    managed_pipeline_mode       = "Integrated"
    minimum_tls_version         = "1.2"
    remote_debugging_enabled    = false
    scm_minimum_tls_version     = "1.2"
    scm_use_main_ip_restriction = false
    vnet_route_all_enabled      = true
    websockets_enabled          = false
  }

  enable_vnet_integration = true
  subnet_id               = module.vnet_main.subnet_ids["app-subnet"]

  application_insights_enabled = true

  #    provide the application_insights_id  if you already have a application insights
  #    if not then this module will create a application insights by providing a application insights name

  # application_insights_id    = null
  app_insights_name = "webAppInisghts"


  # enable backup for App  Service (Bydefault  it is false)
  # You can configure the backups to be retained up to an indefinite amount of time.
  # This module creates a Storage Container to keep the all backup items. 
  enable_backup        = true
  storage_account_name = "storageaccount101"
  backup_settings = {
    enabled                  = true
    name                     = "DefaultBackup"
    frequency_interval       = 1
    frequency_unit           = "Day"
    retention_period_in_days = 30
  }
}