output "linux_web_app_default_site_hostname" {
  description = "The Default Hostname associated with the App Service"
  value       = var.os_type == "Linux" ? format("https://%s/", azurerm_linux_web_app.web_App.0.default_hostname) : null
}

output "Windows_web_app_default_site_hostname" {
  description = "The Default Hostname associated with the App Service"
  value       = var.os_type == "Windows" ? format("https://%s/", azurerm_windows_web_app.web_App.0.default_hostname) : null
}