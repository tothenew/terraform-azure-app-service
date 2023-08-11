# terraform-aws-template

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
| resource_group_name | Name of the Resource Group     | string   |         | yes      |
| location            | Location for the Resource Group| string   |         | yes      |
| default_tags        | Default tags for resources     | map      |         | yes      |
| common_tags         | Common tags for resources      | map      |         | yes      |


### Virtual Network and Subnets

It will deploy an Azure Virtual Network with multiple subnets, each with specific delegations and service endpoints.

### Inputs

#### Virtual Network Inputs

| Name                 | Description                      | Type     | Default | Required |
|----------------------|----------------------------------|----------|---------|----------|
| vnet-name            | Name of the Virtual Network      | string   |         | yes      |
| location             | Location of the Virtual Network  | string   |         | yes      |
| vnetcidr             | Address space of the VNet        | list     |         | yes      |
| default_tags         | Default tags for resources       | map      |         | yes      |
| common_tags          | Common tags for resources        | map      |         | yes      |
| name_prefix          | Prefix for naming resources      | string   |         | yes      |

#### Application Gateway Subnet Inputs

| Name                                 | Description                            | Type     | Default | Required |
|--------------------------------------|----------------------------------------|----------|---------|----------|
| app_gateway_subnet_name              | Name of the Application Gateway subnet | string   |         | yes      |
| app_gateway_address_prefixe          | Address prefixes for the subnet        | list     |         | yes      |
| app_gateway_subnet_service_endpoint  | Service endpoints for the subnet       | list     |         | yes      |

#### App Service Subnet Inputs

| Name                             | Description                        | Type     | Default | Required |
|----------------------------------|------------------------------------|----------|---------|----------|
| app_service_subnet_name          | Name of the App Service subnet     | string   |         | yes      |
| app_service_address_prefixe      | Address prefixes for the subnet    | list     |         | yes      |
| app_subnet_delegation_name       | Name of the delegation             | string   |         | yes      |
| app_subnet_service_delegation_actions | Actions for service delegation  | list     |         | yes      |
| app_subnet_service_delegation_name | Name of the service delegation   | string   |         | yes      |

#### Database Subnet Inputs

| Name                       | Description                    | Type     | Default | Required |
|----------------------------|--------------------------------|----------|---------|----------|
| db_subnet_name             | Name of the Database subnet    | string   |         | yes      |
| db_subnet_address_prefixe  | Address prefixes for the subnet| list     |         | yes      |
| db_subnet_service_endpoint | Service endpoints for the subnet| list     |         | yes      |
| db_subnet_delegation_name  | Name of the delegation         | string   |         | yes      |
| db_subnet_service_delegation_actions | Actions for service delegation | list |         | yes      |
| db_subnet_service_delegation_name | Name of the service delegation | string |       | yes    |


### Linux web App

### Inputs

| Name                                       | Description                                  | Type           | Default | Required |
|--------------------------------------------|----------------------------------------------|----------------|---------|----------|
| create_web_app                             | Whether to create the Linux Web App          | bool           | false   | yes      |
| app_service_plan_name                      | Name of the App Service Plan                 | string         |         | yes      |
| location                                   | Location where resources will be deployed    | string         |         | yes      |
| os_type                                    | OS type of the Web App (Linux/Windows)       | string         |         | yes      |
| sku_name                                   | SKU name of the App Service Plan             | string         |         | yes      |
| linux_web_app_name                         | Name of the Linux Web App                    | string         |         | yes      |
| public_network_access_enabled               | Whether public network access is enabled     | bool           | false   | yes      |
| always_on                                  | Whether the app should always be on          | bool           | false   | no       |
| container_registry_use_managed_identity    | Use managed identity for container registry  | bool           | false   | no       |
| load_balancing_mode                        | Load balancing mode of the app               | string         |         | no       |
| ip_restriction_action                      | IP restriction action                        | string         |         | no       |
| ip_restriction_priority                    | IP restriction priority                      | int            |         | no       |


## Creating Application Gateway with Backend Pool

It will deploy an Azure Application Gateway with a backend pool that includes a Linux Web App.

### Inputs

| Name                                       | Description                                  | Type           | Default | Required |
|--------------------------------------------|----------------------------------------------|----------------|---------|----------|
| public_ip_name                             | Name of the Public IP                        | string         |         | yes      |
| allocation_method                          | IP allocation method                        | string         |         | yes      |
| public_ip_sku                              | SKU of the Public IP                        | string         |         | yes      |
| app_gateway_name                           | Name of the Application Gateway             | string         |         | yes      |
| app_gateway_sku_name                       | SKU name of the Application Gateway         | string         |         | yes      |
| app_gateway_sku_tier                       | SKU tier of the Application Gateway         | string         |         | yes      |
| app_gateway_sku_capacity                   | SKU capacity of the Application Gateway     | int            |         | no       |
| frontend_port                              | Frontend port for Application Gateway       | int            |         | yes      |
| protocol                                   | Protocol for health probe                   | string         |         | yes      |
| path                                       | Path for health probe                       | string         |         | yes      |
| probe_interval                             | Health probe interval                       | int            |         | yes      |
| probe_timeout                              | Health probe timeout                        | int            |         | yes      |
| probe_unhealthy_threshold                  | Health probe unhealthy threshold            | int            |         | yes      |
| pick_host_name_from_backend_http_settings   | Pick hostname from backend settings         | bool           |         | yes      |
| match_body                                 | Match body for health probe                 | string         |         | yes      |
| match_status_code                          | Match status code for health probe          | string         |         | yes      |
| cookie_based_affinity                      | Cookie-based affinity                       | string         |         | no       |
| pick_host_name_from_backend_address         | Pick hostname from backend address          | bool           |         | no       |
| port                                       | Port for backend HTTP settings              | int            |         | yes      |
| request_timeout                            | Request timeout for backend HTTP settings   | int            |         | yes      |
| priority                                   | Priority for routing rule                   | int            |         | yes      |

### Outputs

| Name                                       | Description                                  | Type           |
|--------------------------------------------|----------------------------------------------|----------------|
| applicaiton_gateway_ip                          | Ip address of Application Gateway       | string         |

## Authors

Module managed by [TO THE NEW Pvt. Ltd.](https://github.com/tothenew)

## License

Apache 2 Licensed. See [LICENSE](https://github.com/tothenew/terraform-aws-template/blob/main/LICENSE) for full details.
