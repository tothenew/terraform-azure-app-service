resource "azurerm_resource_group" "appService-rg" {
  name     = var.resource_group_name
  location = var.location
  
  tags = merge(var.default_tags, var.common_tags , {
    "Name"        = "${var.name_prefix}",
  })
}