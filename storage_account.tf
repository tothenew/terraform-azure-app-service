
resource "azurerm_storage_container" "storage_cont" {
  count                 = var.enable_backup ? 1 : 0
  name                  = var.storage_container_name == null ? "appservice-backup" : var.storage_container_name
  storage_account_name  = data.azurerm_storage_account.storage_acc.0.name
  container_access_type = var.container_access_type
}

resource "time_rotating" "main" {
  count            = var.enable_backup ? 1 : 0
  rotation_rfc3339 = var.password_end_date
  rotation_years   = var.password_rotation_in_years

  triggers = {
    end_date = var.password_end_date
    years    = var.password_rotation_in_years
  }
}

data "azurerm_storage_account_blob_container_sas" "main" {
  count             = var.enable_backup ? 1 : 0
  connection_string = data.azurerm_storage_account.storage_acc.0.primary_connection_string
  container_name    = azurerm_storage_container.storage_cont.0.name
  https_only        = var.https_only

  start  = timestamp()
  expiry = time_rotating.main.0.rotation_rfc3339

  permissions {
    read   = var.permissions.read
    add    = var.permissions.add
    create = var.permissions.create
    write  = var.permissions.write
    delete = var.permissions.delete
    list   = var.permissions.list
  }

  cache_control       = var.blob_container_sas.cache_control
  content_disposition = var.blob_container_sas.content_disposition
  content_encoding    = var.blob_container_sas.content_encoding
  content_language    = var.blob_container_sas.content_language
  content_type        = var.blob_container_sas.content_type
}