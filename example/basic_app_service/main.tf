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
}