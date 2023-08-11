output "applicaiton_gateway_ip" {
  value = azurerm_public_ip.public_ip.ip_address
}