module "Azure_App_Service" {
    source      = "git::https://github.com/tothenew/terraform-azure-app-service.git?ref=azure-app-service-v1"

    resource_group_name         = "app-service-rg"
    location                    = "EAST US 2" 
    vnet_name                   = "app_service_vnet"
    vnetcidr                    = "10.0.0.0/16"

    app_gateway_subnet_name     = "my-app-gateway-subnet"
    app_gateway_address_prefixe = ["10.0.1.0/24"]
    app_service_subnet_name     = "my-app-service-subnet"
    app_service_address_prefixe =  ["10.0.2.0/24"]
    db_subnet_name              = "my-db-subnet"
    db_subnet_address_prefixe   = ["10.0.3.0/24"]
}