resource "azurerm_service_plan" "service_plan" {
  # count                      = var.create_web_app ? 1:0
  name                       = var.app_service_plan_name
  resource_group_name        = azurerm_resource_group.appService-rg.name
  location                   = var.location
  os_type                    = var.os_type
  sku_name                   = var.sku_name

  tags = merge(var.default_tags, var.common_tags , {
    "Name"        = "${var.name_prefix}",
  })
}

resource "azurerm_linux_web_app" "web_App" {
  # count               = var.create_web_app ? 1:0
  name                = var.linux_web_app_name
  resource_group_name = azurerm_resource_group.appService-rg.name
  location            = var.location
  service_plan_id     = azurerm_service_plan.service_plan.id
  public_network_access_enabled =  var.public_network_access_enabled

  site_config {
        always_on                               = var.always_on
        container_registry_use_managed_identity = var.container_registry_use_managed_identity
        load_balancing_mode                     = var.load_balancing_mode
   ip_restriction {
      action = var.ip_restriction_action
      priority = var.ip_restriction_priority
      virtual_network_subnet_id = azurerm_subnet.app_gateway_subnet.id
    }
  }

 tags = merge(var.default_tags, var.common_tags , {
    "Name"        = "${var.name_prefix}",
  })
}

resource "azurerm_app_service_virtual_network_swift_connection" "vnet_swift_connection" {
  # count          = var.create_web_app ? 1:0
  app_service_id = azurerm_linux_web_app.web_App.id
  subnet_id      = azurerm_subnet.app_service_subnet.id
}


