# terraform-azure-app-service

[![Lint Status](https://github.com/tothenew/terraform-aws-template/workflows/Lint/badge.svg)](https://github.com/tothenew/terraform-aws-template/actions)
[![LICENSE](https://img.shields.io/github/license/tothenew/terraform-aws-template)](https://github.com/tothenew/terraform-aws-template/blob/master/LICENSE)

This Terraform will deploy a Linux Web App and establishes a virtual network connection to the web app through service endpoint so that the web app is only accessable through application gateway.

## Prerequisites

Before you begin, ensure you have the following requirements met:

1. Install Terraform (>= 1.3.0). You can download the latest version of Terraform from the official website: [https://www.terraform.io/downloads.html](https://www.terraform.io/downloads.html)

2. Azure CLI installed and configured with appropriate access rights. You can install the Azure CLI from [https://docs.microsoft.com/en-us/cli/azure/install-azure-cli](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)


### Azure Resource Group

This Terraform configuration deploys an Azure Resource Group with specified attributes.

### Inputs

| Name                | Description                    | Type     | Default | Required |
|---------------------|--------------------------------|----------|---------|----------|
| resource_group_name | Name of the Resource Group     | string   | "app-service-rg"   | yes      |
| location            | Location for the Resource Group| string   | "EAST US 2"    | yes      |
| default_tags        | Default tags for resources     | map      |  default = {
    "Scope" : "database"
    "CreatedBy" : "Terraform"
  } | yes      |
| common_tags         | Common tags for resources      | map      |  default = {
    Project    = "Azure_database",
    Managed-By = "TTN",
  }       | yes      |


### Virtual Network and Subnets

It will deploy an Azure Virtual Network with multiple subnets, each with specific delegations and service endpoints.

### Inputs

#### Virtual Network Inputs

| Name                 | Description                      | Type     | Default | Required |
|----------------------|----------------------------------|----------|---------|----------|
| vnet-name            | Name of the Virtual Network      | string   | "app_service_vnet" | yes      |
| location             | Location of the Virtual Network  | string   | EAST US 2"        | yes      |
| vnetcidr             | Address space of the VNet        | list     | "10.0.0.0/16"      | yes      |
| default_tags         | Default tags for resources       | map      |         | yes      |
| common_tags          | Common tags for resources        | map      |         | yes      |
| name_prefix          | Prefix for naming resources      | string   |         | yes      |

#### Application Gateway Subnet Inputs

| Name                                 | Description                            | Type     | Default | Required |
|--------------------------------------|----------------------------------------|----------|---------|----------|
| app_gateway_subnet_name              | Name of the Application Gateway subnet | string   | "my-app-gateway-subnet"       | yes      |
| app_gateway_address_prefixe          | Address prefixes for the subnet        | list     |  ["10.0.1.0/24"]        | yes      |
| app_gateway_subnet_service_endpoint  | Service endpoints for the subnet       | list     |         | yes      |

#### App Service Subnet Inputs

| Name                             | Description                        | Type     | Default | Required |
|----------------------------------|------------------------------------|----------|---------|----------|
| app_service_subnet_name          | Name of the App Service subnet     | string   |   "my-app-service-subnet"       | yes      |
| app_service_address_prefixe      | Address prefixes for the subnet    | list     |  ["10.0.2.0/24"]       | yes      |
| app_subnet_delegation_name       | Name of the delegation             | string   |         | yes      |
| app_subnet_service_delegation_actions | Actions for service delegation  | list     |         | yes      |
| app_subnet_service_delegation_name | Name of the service delegation   | string   |         | yes      |

#### Database Subnet Inputs

| Name                       | Description                    | Type     | Default | Required |
|----------------------------|--------------------------------|----------|---------|----------|
| db_subnet_name             | Name of the Database subnet    | string   |   "my-db-subnet"      | yes      |
| db_subnet_address_prefixe  | Address prefixes for the subnet| list     |  ["10.0.3.0/24"]      | yes      |
| db_subnet_service_endpoint | Service endpoints for the subnet| list     |         | yes      |
| db_subnet_delegation_name  | Name of the delegation         | string   |         | yes      |
| db_subnet_service_delegation_actions | Actions for service delegation | list |         | yes      |
| db_subnet_service_delegation_name | Name of the service delegation | string |       | yes    |


### Linux web App

### Inputs

| Name                                       | Description                                  | Type           | Default | Required |
|--------------------------------------------|----------------------------------------------|----------------|---------|----------|
| app_service_plan_name                      | Name of the App Service Plan                 | string         |  "myAppServicePlan"       | yes      |
| location                                   | Location where resources will be deployed    | string         |          | yes      |
| os_type                                    | OS type of the Web App (Linux/Windows)       | string         | "Linux"        | yes      |
| sku_name                                   | SKU name of the App Service Plan             | string         |   "P1v2"      | yes      |
| linux_web_app_name                         | Name of the Linux Web App                    | string         | "myApp000110"        | yes      |
| public_network_access_enabled               | Whether public network access is enabled     | bool           | true   | yes      |
| always_on                                  | Whether the app should always be on          | bool           | false   | no       |
| container_registry_use_managed_identity    | Use managed identity for container registry  | bool           | false   | no       |
| load_balancing_mode                        | Load balancing mode of the app               | string         | "LeastRequests"        | no       |
| ip_restriction_action                      | IP restriction action                        | string         |  "Allow"       | no       |
  default = 200
| ip_restriction_priority                    | IP restriction priority                      | int            |         | no       |


## Creating Application Gateway with Backend Pool

It will deploy an Azure Application Gateway with a backend pool that includes a Linux Web App.

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

| Name                                       | Description                                  | Type           |
|--------------------------------------------|----------------------------------------------|----------------|
| applicaiton_gateway_ip                          | Ip address of Application Gateway       | string         |

## Authors

Module managed by [TO THE NEW Pvt. Ltd.](https://github.com/tothenew)

## License

Apache 2 Licensed. See [LICENSE](https://github.com/tothenew/terraform-aws-template/blob/main/LICENSE) for full details.
