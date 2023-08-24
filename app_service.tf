resource "azurerm_service_plan" "service_plan" {
  name                = var.app_service_plan_name
  resource_group_name = local.resource_group_name
  location            = var.location
  os_type             = var.os_type
  sku_name            = var.sku_name

  tags = merge(var.default_tags, var.common_tags, {
    "Name" = "${local.project_name_prefix}",
  })
}

resource "azurerm_linux_web_app" "web_App" {
  count                         = var.os_type == "Linux" ? 1 : 0
  name                          = var.web_app_name
  resource_group_name           = local.resource_group_name
  location                      = var.location
  service_plan_id               = azurerm_service_plan.service_plan.id
  public_network_access_enabled = var.public_network_access_enabled
  app_settings                  = merge(local.default_app_settings, var.app_settings)

  site_config {
    always_on                   = var.site_config.always_on
    http2_enabled               = var.site_config.http2_enabled
    load_balancing_mode         = var.site_config.load_balancing_mode
    managed_pipeline_mode       = var.site_config.managed_pipeline_mode
    minimum_tls_version         = var.site_config.minimum_tls_version
    remote_debugging_enabled    = var.site_config.remote_debugging_enabled
    scm_minimum_tls_version     = var.site_config.scm_minimum_tls_version
    scm_use_main_ip_restriction = var.site_config.scm_use_main_ip_restriction
    vnet_route_all_enabled      = var.site_config.vnet_route_all_enabled
    websockets_enabled          = var.site_config.websockets_enabled

    dynamic "cors" {
      for_each = var.cors
      content {
        allowed_origins = lookup(cors.value, "allowed_origins", [])
      }
    }
  }

  auth_settings {
    enabled                        = var.enable_auth_settings
    default_provider               = var.default_auth_provider
    allowed_external_redirect_urls = []
    issuer                         = format("https://sts.windows.net/%s/", data.azurerm_client_config.main.tenant_id)
    unauthenticated_client_action  = var.unauthenticated_client_action
    token_store_enabled            = var.token_store_enabled

    dynamic "active_directory" {
      for_each = var.active_directory_auth_setttings
      content {
        client_id     = lookup(active_directory_auth_setttings.value, "client_id", null)
        client_secret = lookup(active_directory_auth_setttings.value, "client_secret", null)
      }
    }
  }

  dynamic "connection_string" {
    for_each = var.connection_strings
    content {
      name  = lookup(connection_string.value, "name", null)
      type  = lookup(connection_string.value, "type", null)
      value = lookup(connection_string.value, "value", null)
    }
  }


  dynamic "backup" {
    for_each = var.enable_backup ? [{}] : []
    content {
      name                = var.backup_settings.name
      enabled             = var.backup_settings.enabled
      storage_account_url = format("https://${data.azurerm_storage_account.storage_acc.0.name}.blob.core.windows.net/${azurerm_storage_container.storage_cont.0.name}%s", data.azurerm_storage_account_blob_container_sas.main.0.sas)
      schedule {
        frequency_interval    = var.backup_settings.frequency_interval
        frequency_unit        = var.backup_settings.frequency_unit
        retention_period_days = var.backup_settings.retention_period_days
        start_time            = var.backup_settings.start_time
      }
    }
  }


  dynamic "storage_account" {
    for_each = var.storage_mounts
    content {
      name         = lookup(storage_account.value, "name")
      type         = lookup(storage_account.value, "type", "AzureFiles")
      account_name = lookup(storage_account.value, "account_name", null)
      share_name   = lookup(storage_account.value, "share_name", null)
      access_key   = lookup(storage_account.value, "access_key", null)
      mount_path   = lookup(storage_account.value, "mount_path", null)
    }
  }


  identity {
    type = var.identity
  }

  tags = merge(var.default_tags, var.common_tags, {
    "Name" = "${var.project_name_prefix}",
  })
}

resource "azurerm_app_service_virtual_network_swift_connection" "linux_vnet_swift_connection" {
  count          = var.os_type == "Linux" && var.enable_vnet_integration == true ? 1 : 0
  app_service_id = azurerm_linux_web_app.web_App.0.id
  subnet_id      = var.subnet_id
}

resource "azurerm_windows_web_app" "web_App" {
  count                         = var.os_type == "Windows" ? 1 : 0
  name                          = var.web_app_name
  resource_group_name           = local.resource_group_name
  location                      = var.location
  service_plan_id               = azurerm_service_plan.service_plan.id
  public_network_access_enabled = var.public_network_access_enabled
  app_settings                  = merge(local.default_app_settings, var.app_settings)

  site_config {
    always_on                   = var.site_config.always_on
    http2_enabled               = var.site_config.http2_enabled
    load_balancing_mode         = var.site_config.load_balancing_mode
    managed_pipeline_mode       = var.site_config.managed_pipeline_mode
    minimum_tls_version         = var.site_config.minimum_tls_version
    remote_debugging_enabled    = var.site_config.remote_debugging_enabled
    scm_minimum_tls_version     = var.site_config.scm_minimum_tls_version
    scm_use_main_ip_restriction = var.site_config.scm_use_main_ip_restriction
    vnet_route_all_enabled      = var.site_config.vnet_route_all_enabled
    websockets_enabled          = var.site_config.websockets_enabled

    dynamic "cors" {
      for_each = var.cors
      content {
        allowed_origins = lookup(cors.value, "allowed_origins", [])
      }
    }
  }

  auth_settings {
    enabled                        = var.enable_auth_settings
    default_provider               = var.default_auth_provider
    allowed_external_redirect_urls = []
    issuer                         = format("https://sts.windows.net/%s/", data.azurerm_client_config.main.tenant_id)
    unauthenticated_client_action  = var.unauthenticated_client_action
    token_store_enabled            = var.token_store_enabled

    dynamic "active_directory" {
      for_each = var.active_directory_auth_setttings
      content {
        client_id     = lookup(active_directory_auth_setttings.value, "client_id", null)
        client_secret = lookup(active_directory_auth_setttings.value, "client_secret", null)
      }
    }
  }

  dynamic "connection_string" {
    for_each = var.connection_strings
    content {
      name  = lookup(connection_string.value, "name", null)
      type  = lookup(connection_string.value, "type", null)
      value = lookup(connection_string.value, "value", null)
    }
  }


  dynamic "backup" {
    for_each = var.enable_backup ? [{}] : []
    content {
      name                = var.backup_settings.name
      enabled             = var.backup_settings.enabled
      storage_account_url = format("https://${data.azurerm_storage_account.storage_acc.0.name}.blob.core.windows.net/${azurerm_storage_container.storage_cont.0.name}%s", data.azurerm_storage_account_blob_container_sas.main.0.sas)
      schedule {
        frequency_interval    = var.backup_settings.frequency_interval
        frequency_unit        = var.backup_settings.frequency_unit
        retention_period_days = var.backup_settings.retention_period_days
        start_time            = var.backup_settings.start_time
      }
    }
  }


  dynamic "storage_account" {
    for_each = var.storage_mounts
    content {
      name         = lookup(storage_account.value, "name")
      type         = lookup(storage_account.value, "type", "AzureFiles")
      account_name = lookup(storage_account.value, "account_name", null)
      share_name   = lookup(storage_account.value, "share_name", null)
      access_key   = lookup(storage_account.value, "access_key", null)
      mount_path   = lookup(storage_account.value, "mount_path", null)
    }
  }


  tags = merge(var.default_tags, var.common_tags, {
    "Name" = "${var.project_name_prefix}",
  })
}

resource "azurerm_app_service_virtual_network_swift_connection" "windows_vnet_swift_connection" {
  count          = var.os_type == "Windows" && var.enable_vnet_integration ? 1 : 0
  app_service_id = azurerm_windows_web_app.web_App.0.id
  subnet_id      = var.subnet_id
}
  