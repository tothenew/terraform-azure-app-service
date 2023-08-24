data "azurerm_application_insights" "main" {
  count               = var.application_insights_enabled && var.application_insights_id != null ? 1 : 0
  name                = var.application_insights_id
  resource_group_name = var.application_insights_id
}

resource "azurerm_application_insights" "main" {
  count               = var.application_insights_enabled && var.application_insights_id == null ? 1 : 0
  name                = lower(format("appi-%s", var.app_insights_name))
  resource_group_name = local.resource_group_name
  location            = var.location
  application_type    = var.application_insights_type
  retention_in_days   = var.retention_in_days
  disable_ip_masking  = var.disable_ip_masking

  tags = merge(var.default_tags, var.common_tags, {
    "Name" = "${var.project_name_prefix}",
  })

}