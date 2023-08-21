# terraform {
#   backend "azurerm" {
#     resource_group_name  = "example_rg_name"
#     storage_account_name = "example_ac_name"
#     container_name       = "example_container_name" 
#     key                  = "example.terraform.tfstate"
#   }
# }  