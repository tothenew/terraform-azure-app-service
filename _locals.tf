locals {

  project_name_prefix = var.project_name_prefix == "" ? terraform.workspace : var.project_name_prefix
  common_tags         = length(var.common_tags) == 0 ? var.default_tags : merge(var.default_tags, var.common_tags)

  resource_group_name = element(coalescelist(data.azurerm_resource_group.rg.*.name, azurerm_resource_group.appService-rg.*.name, [""]), 0)

  backend_address_pool_name      = "backend-pool-1"
  frontend_port_name             = "frontend-port"
  frontend_ip_configuration_name = "frontedn-ip-1"
  http_setting_name              = "backend-httpsetting-1"
  listener_name                  = "http-listener-1"
  request_routing_rule_name      = "routing-rule-1"
  redirect_configuration_name    = "redirect_config-name"
  backend_probe_name             = "probe-1"
  priority                       = 1

  app_insights = try(data.azurerm_application_insights.main.0, try(azurerm_application_insights.main.0, {}))

  default_app_settings = var.application_insights_enabled ? {
    APPLICATION_INSIGHTS_IKEY                  = try(local.app_insights.instrumentation_key, "")
    APPINSIGHTS_INSTRUMENTATIONKEY             = try(local.app_insights.instrumentation_key, "")
    APPLICATIONINSIGHTS_CONNECTION_STRING      = try(local.app_insights.connection_string, "")
    ApplicationInsightsAgent_EXTENSION_VERSION = "~2"
  } : {}

}
