resource "azurerm_public_ip" "public_ip" {
  count               = var.create_application_gateway ? 1 : 0
  name                = var.public_ip_name
  resource_group_name = local.resource_group_name
  location            = var.location
  allocation_method   = var.allocation_method
  sku                 = var.public_ip_sku

  tags = merge(var.default_tags, var.common_tags, {
    "Name" = "${var.project_name_prefix}",
  })
}

resource "azurerm_application_gateway" "app_gateway" {
  count               = var.create_application_gateway ? 1 : 0
  name                = var.app_gateway_name
  resource_group_name = local.resource_group_name
  location            = var.location

  sku {
    name     = var.app_gateway_sku_name
    tier     = var.app_gateway_sku_tier
    capacity = var.app_gateway_sku_capacity
  }

  gateway_ip_configuration {
    name      = var.gateway_ip_configuration_name
    subnet_id = var.app_gateway_subnet_id
  }

  frontend_port {
    name = local.frontend_port_name
    port = var.frontend_port
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.public_ip.0.id
  }

  backend_address_pool {
    name  = local.backend_address_pool_name
    fqdns = [var.os_type == "Linux" ? azurerm_linux_web_app.web_App.0.default_hostname : azurerm_windows_web_app.web_App.0.default_hostname]
  }

  probe {
    name                                      = local.backend_probe_name
    protocol                                  = var.protocol
    path                                      = var.path
    interval                                  = var.probe_interval
    timeout                                   = var.probe_timeout
    unhealthy_threshold                       = var.probe_unhealthy_threshold
    pick_host_name_from_backend_http_settings = var.pick_host_name_from_backend_http_settings

    match {
      body        = var.match_body
      status_code = var.match_status_code
    }
  }

  backend_http_settings {
    name                                = local.http_setting_name
    cookie_based_affinity               = var.cookie_based_affinity
    pick_host_name_from_backend_address = var.pick_host_name_from_backend_address
    path                                = var.path
    port                                = var.port
    protocol                            = var.protocol
    request_timeout                     = var.request_timeout
  }


  http_listener {
    name                           = local.listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name
    protocol                       = var.protocol
  }

  request_routing_rule {
    name                       = local.request_routing_rule_name
    rule_type                  = var.request_routing_rule_type
    http_listener_name         = local.listener_name
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.http_setting_name
    priority                   = local.priority
  }

  tags = merge(var.default_tags, var.common_tags, {
    "Name" = "${var.project_name_prefix}",
  })
}