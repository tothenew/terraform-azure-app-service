resource "azurerm_resource_group" "appService-rg" {
  count    = var.create_resource_group ? 1 : 0
  name     = var.resource_group_name
  location = var.location

  tags = merge(var.default_tags, var.common_tags, {
    "Name" = "${var.project_name_prefix}",
  })
}