resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  resource_group_name = azurerm_resource_group.appService-rg.name
  location            = var.location
  address_space       = [var.vnetcidr]
 
  tags = merge(var.default_tags, var.common_tags , {
    "Name"        = "${var.name_prefix}",
  })
}


############################################################################################
#####             subnet with service endpoint for application gateway                 #####
############################################################################################

resource "azurerm_subnet" "app_gateway_subnet" {
  name                 = var.app_gateway_subnet_name
  resource_group_name  = azurerm_resource_group.appService-rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.app_gateway_address_prefixe
  service_endpoints    = var.app_gateway_subnet_service_endpoint
}

############################################################################################
#####             subnet with delegation for app service outbound                      #####
############################################################################################
resource "azurerm_subnet" "app_service_subnet" {
  name                 = var.app_service_subnet_name
  resource_group_name  = azurerm_resource_group.appService-rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.app_service_address_prefixe

  delegation {
    name = var.app_subnet_delegation_name

    service_delegation {
        actions = var.app_subnet_service_delegation_actions
        name  = var.app_subnet_service_delegation_name
      }
  }
}


############################################################################################
#####             subnet with delegation for database                                  #####
############################################################################################
resource "azurerm_subnet" "db_subnet" {
  name                 = var.db_subnet_name
  resource_group_name  = azurerm_resource_group.appService-rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.db_subnet_address_prefixe
  service_endpoints    = var.db_subnet_service_endpoint
  delegation {
    name = var.db_subnet_delegation_name
    service_delegation {
      name = var.db_subnet_service_delegation_name
      actions = var.db_subnet_service_delegation_actions
    }
  }
}