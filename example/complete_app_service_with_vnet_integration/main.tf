provider "azurerm" {
  features {}
}


module "vnet" {
  source  = "git::https://github.com/tothenew/terraform-azure-app-service.git?ref=azure-app-service-v1"

  create_resource_group  = false
  resource_group_name    = "vnet-rg"
  vnetwork_name          = "vnet-shared-hub-westeurope-002"
  location               = "westeurope"
  vnet_address_space     = ["10.2.0.0/16"]

  subnets = {
    web_subnet = {
      subnet_name           = "webapp-subnet"
      subnet_address_prefix = ["10.2.1.0/24"]
      delegation = {
        name = "testdelegation"
        service_delegation = {
          name    = "Microsoft.Web/serverFarms"
          actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
        }
      }
    }
  }
}

module "vnet_main" {
  source = "git::https://github.com/DeepakBoora/terraform-azure-vnet-setup"

  resource_group_name = azurerm_resource_group.main.name
  location = azurerm_resource_group.main.location

  address_space     = "10.0.0.0/16"  
  subnets = {
     "app_subnet" = {
      address_prefixes = ["10.0.1.0/24"]
      associate_with_route_table = false  
      is_natgateway = false 
      is_nsg = false
      service_delegation = true
      delegation_name =  "Microsoft.Web/serverFarms"
      delegation_actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }   

    "app_gateway_subnet" = {
    address_prefixes = ["10.0.2.0/24"]
    associate_with_route_table = false    
    } 
  }
}


module "Azure_App_Service" {
    source      = "git::https://github.com/tothenew/terraform-azure-app-service.git?ref=azure-app-service-v1"

    resource_group_name     = "app-service-rg"
    location                = "EAST US 2"  

    os_type                 = "Linux"
    sku_name                = "B2"

    web_app_name                  = "myApp000110"
    public_network_access_enabled = true

    site_config = {
        always_on                       = true
        http2_enabled                   = false
        load_balancing_mode             = "LeastRequests"
        managed_pipeline_mode           = "Integrated"
        minimum_tls_version             = "1.2"  
        remote_debugging_enabled        = false  
        scm_minimum_tls_version         = "1.2"  
        scm_use_main_ip_restriction     = false                
        websockets_enabled              = false
    }

    enable_vnet_integration      = true
    subnet_id                    = element(module.vnet.subnet_ids, 0)

    application_insights_enabled = true
   
#    change the value of application_insights_id if you already have a application insights
#    if not then this module will create a application insights by providing a application insights name

    # application_insights_id    = null
    app_insights_name            = "otkpocshared"
    

  # The Backup feature in Azure App Service easily create app backups manually or on a schedule.
  # You can configure the backups to be retained up to an indefinite amount of time.
  # Azure storage account and container in the same subscription as the app that you want to back up. 
  # This module creates a Storage Container to keep the all backup items. 
    enable_backup        = true
    storage_account_name = "stdiagfortesting1"
    backup_settings = {
       enabled                  = true
       name                     = "DefaultBackup"
       frequency_interval       = 1
       frequency_unit           = "Day"
       retention_period_in_days = 30
    }   
}