data "azurerm_client_config" "main" {}

data "azurerm_storage_account" "storage_acc" {
  count               = var.enable_backup ? 1 : 0
  name                = var.storage_account_name
  resource_group_name = var.storage_acc_resource_group_name
}

data "azurerm_resource_group" "rg" {
  count = var.create_resource_group ? 0 : 1
  name  = var.resource_group_name
}
