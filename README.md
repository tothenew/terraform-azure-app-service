# terraform-azure-app-service

[![Lint Status](https://github.com/tothenew/terraform-aws-template/workflows/Lint/badge.svg)](https://github.com/tothenew/terraform-aws-template/actions)
[![LICENSE](https://img.shields.io/github/license/tothenew/terraform-aws-template)](https://github.com/tothenew/terraform-aws-template/blob/master/LICENSE)

This Terraform will deploy a basic and complete azure app service (linux web app and window web app) and azure app service with application gateway.

The following resources will be created:
 - Resource Group
 - Azure App Service
 - Application Insights
 - Application Gateway
 - Shared Access Signature (SAS Token) for an existing Storage Account.



## Providers

| Name | Version |
|------|---------|
| <a name="provider_Azure"></a> [azurerm](#provider\_azure) | >=3.0 |

## Prerequisites

Before you begin, ensure you have the following requirements met:

1. Install Terraform (>= 1.3.0). You can download the latest version of Terraform from the official website: [https://www.terraform.io/downloads.html](https://www.terraform.io/downloads.html)

2. Azure CLI installed and configured with appropriate access rights. You can install the Azure CLI from [https://docs.microsoft.com/en-us/cli/azure/install-azure-cli](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)


## Resources

| Name                                     | Description                                                            | Type              |
|------------------------------------------|------------------------------------------------------------------------|-------------------|
| azurerm_resource_group | Azure Resource Group         | azurerm           |
| azurerm_service_plan                      | Azure App Service Plan.                                                | azurerm           |
| azurerm_linux_web_app                    | Azure Linux Web App.                                                   | azurerm           |
| azurerm_app_service_virtual_network_swift_connection | Swift connection settings for VNet integration.          | azurerm           |
| azurerm_application_insights                      | Azure Application Insights                                                | azurerm           |
| azurerm_storage_container                   | Azure Storage resources for backup purposes.                                                | azurerm           |
| azurerm_public_ip | Azure public ip for applicaiton gateway          | azurerm           |
| azurerm_application_gateway | Azure applicaiton gateway          | azurerm           |


### Azure Resource Group

This Terraform configuration deploys an Azure Resource Group

### Inputs

| Name                | Description                    | Type     | Default | Required |
|---------------------|--------------------------------|----------|---------|----------|
| resource_group_name | Name of the Resource Group     | string   | "app-service-rg"   | yes      |
| location            | Location for the Resource Group| string   | "EAST US 2"    | yes      |

## Azure App Service

This Terraform configuration deploys an Azure App Service that include linux web app and window web app and it depends on the os_type (linux or window).

### Inputs

| Name                                     | Description                                                            | Type      | Default               | Required |
|------------------------------------------|------------------------------------------------------------------------|-----------|-----------------------|----------|
| app_service_plan_name                    | The name of the Azure App Service Plan.                               | string    | n/a                   | yes      |
| resource_group_name                      | The name of the Azure Resource Group where resources will be deployed.| string    | n/a                   | yes      |
| location                                 | The Azure region where resources will be deployed.                     | string    | n/a                   | yes      |
| os_type                                  | The operating system for the web app (Linux or Windows).               | string    | n/a                   | yes      |
| sku_name                                 | The SKU name for the App Service Plan.                                 | string    | n/a                   | yes      |
| public_network_access_enabled             | Specifies whether public network access is enabled.                    | bool      | n/a                   | yes      |
| app_settings                             | Additional application settings for the web app.                        | map       | n/a                   | yes      |
| site_config                              | Configuration settings for the web app.                                | map       | n/a                   | yes      |
| cors                                     | Cross-Origin Resource Sharing (CORS) settings for the web app.         | list(map) | n/a                   | yes      |
| ip_restriction                           | IP restriction settings for the web app.                                | object    | n/a                   | yes      |
| app_gateway_subnet_id                    | The subnet ID of the Application Gateway for IP restrictions.           | string    | n/a                   | yes      |
| enable_auth_settings                     | Specifies whether authentication settings are enabled.                 | bool      | n/a                   | yes      |
| default_auth_provider                    | The default authentication provider.                                    | string    | n/a                   | yes      |
| active_directory_auth_setttings           | Active Directory authentication settings.                               | map       | n/a                   | yes      |
| unauthenticated_client_action            | Action to take for unauthenticated clients.                             | string    | n/a                   | yes      |
| token_store_enabled                      | Specifies whether token store is enabled.                               | bool      | n/a                   | yes      |
| connection_strings                       | Connection strings for the web app.                                     | list(map) | n/a                   | yes      |
| enable_backup                            | Specifies whether backup settings are enabled.                          | bool      | n/a                   | yes      |
| backup_settings                          | Configuration settings for backups.                                     | map       | n/a                   | yes      |
| storage_mounts                           | Storage mounts for the web app.                                         | list(map) | n/a                   | yes      |
| identity                                 | Identity type for the web app.                                          | string    | n/a                   | yes      |
| enable_vnet_integration                  | Specifies whether VNet integration is enabled.                          | bool      | n/a                   | yes      |
| subnet_id                                | The subnet ID for VNet integration.                                     | string    | n

## Application Insights

This Terraform configuration deploys an Azure Application Insights resource by set application_insights_enabled = true.

### Inputs

| Name                       | Description                                                           | Type     | Default               | Required |
|----------------------------|-----------------------------------------------------------------------|----------|-----------------------|----------|
| application_insights_enabled | Specifies whether to create an Application Insights resource.         | bool     | n/a                   | yes      |
| application_insights_id      | The ID (name) of an existing Application Insights resource to use.    | string   | null                  | no       |
| app_insights_name            | The name of the Application Insights resource.                        | string   | n/a                   | yes      |
| location                     | The Azure region where the Application Insights resource should be created. | string   | n/a                   | yes      |
| application_insights_type    | The type of application to monitor.                                   | string   | "web"                 | no       |
| retention_in_days            | The number of days to retain telemetry data.                          | number   | 30                    | no       |
| disable_ip_masking           | Should IP masking be enabled for this Application Insights resource. | bool     | false                 | no       |


## Azure Storage Backup

This Terraform configuration deploys an Azure Storage resources for backup purposes by set enable_backup = true.

### Inputs

| Name                          | Description                                                        | Type    | Default               | Required |
|-------------------------------|--------------------------------------------------------------------|---------|-----------------------|----------|
| enable_backup                 | Specifies whether to enable the backup functionality.             | bool    | n/a                   | yes      |
| storage_container_name        | The name of the storage container for backup.                      | string  | "appservice-backup"   | no       |
| container_access_type         | The type of access to the storage container.                        | string  | n/a                   | yes      |
| password_end_date             | The end date for password rotation.                                | string  | n/a                   | yes      |
| password_rotation_in_years    | The number of years for password rotation.                         | number  | n/a                   | yes      |
| https_only                    | Specifies whether to enforce HTTPS for the SAS token.              | bool    | n/a                   | yes      |
| permissions                   | Permissions for the SAS token.                                    | object  | n/a                   | yes      |
| blob_container_sas            | Additional configuration for the SAS token.                        | object  | n/a                   | yes      |



## Application Gateway with Backend Pool 

This Terraform configuration deploys an Azure Application Gateway with a backend pool that includes a Azure App Service by set create_application_gateway = true.

### Inputs

| Name                                       | Description                                  | Type           | Default | Required |
|--------------------------------------------|----------------------------------------------|----------------|---------|----------|
| public_ip_name                             | Name of the Public IP                        | string         | "app-gateway-public-ip"        | yes      |
| allocation_method                          | IP allocation method                        | string         |  "Static"      | yes      |
| public_ip_sku                              | SKU of the Public IP                        | string         |   "Standard"       | yes      |
| app_gateway_name                           | Name of the Application Gateway             | string         | "app-service-gateway"        | yes      |
| app_gateway_sku_name                       | SKU name of the Application Gateway         | string         | "Standard_v2"        | yes      |
| app_gateway_sku_tier                       | SKU tier of the Application Gateway         | string         | "Standard_v2"        | yes      |
| app_gateway_sku_capacity                   | SKU capacity of the Application Gateway     | int            | 2        | no       |
| frontend_port                              | Frontend port for Application Gateway       | int            | 80        | yes      |
| protocol                                   | Protocol for health probe                   | string         | "http"        | yes      |
| path                                       | Path for health probe                       | string         |  "/"       | yes      |
| probe_interval                             | Health probe interval                       | int            | 30        | yes      |
| probe_timeout                              | Health probe timeout                        | int            | 120        | yes      |
| probe_unhealthy_threshold                  | Health probe unhealthy threshold            | int            |  3       | yes      |
| pick_host_name_from_backend_http_settings   | Pick hostname from backend settings         | bool           |   true      | yes      |
| match_body                                 | Match body for health probe                 | string         |  "welcome"       | yes      |
| match_status_code                          | Match status code for health probe          | string         | [200, 399]        | yes      |
| cookie_based_affinity                      | Cookie-based affinity                       | string         | "Enabled"        | no       |
| pick_host_name_from_backend_address         | Pick hostname from backend address          | bool           |  true       | no       |
| port                                       | Port for backend HTTP settings              | int            |  80       | yes      |
| request_timeout                            | Request timeout for backend HTTP settings   | int            |  60       | yes      |

### Outputs

| Name                                      | Description                                                  | Type   |
|-------------------------------------------|--------------------------------------------------------------|--------|
| applicaiton_gateway_ip                    | The IP address of the Application Gateway.                   | string |
| linux_web_app_default_site_hostname       | The Default Hostname associated with the Linux Web App.     | string |
| Windows_web_app_default_site_hostname     | The Default Hostname associated with the Windows Web App.   | string | string         |

## Authors

Module managed by [TO THE NEW Pvt. Ltd.](https://github.com/tothenew)

## License

Apache 2 Licensed. See [LICENSE](https://github.com/tothenew/terraform-aws-template/blob/main/LICENSE) for full details.
