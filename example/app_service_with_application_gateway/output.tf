output "applicaiton_gateway_ip" {
  value = var.create_application_gateway ? azurerm_public_ip.public_ip.0.ip_address : null
}