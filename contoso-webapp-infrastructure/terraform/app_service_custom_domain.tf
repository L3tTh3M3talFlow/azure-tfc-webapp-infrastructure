# -------------------------
# App Service Custom Domain
# -------------------------
resource "azurerm_app_service_custom_hostname_binding" "custom_domain" {
  hostname            = var.app_service_custom_domain
  app_service_name    = module.app_service["web"].name
  resource_group_name = module.resource_group.name

  depends_on = [module.app_service]
}

# ------------------------
# App Service Managed Cert
# ------------------------
resource "azurerm_app_service_managed_certificate" "managed_cert" {
  custom_hostname_binding_id = azurerm_app_service_custom_hostname_binding.custom_domain.id
}

# -----------------------------
# Bind App Service Managed Cert
# -----------------------------
resource "azurerm_app_service_certificate_binding" "cert_binding" {
  hostname_binding_id = azurerm_app_service_custom_hostname_binding.custom_domain.id
  certificate_id      = azurerm_app_service_managed_certificate.managed_cert.id
  ssl_state           = "SniEnabled"
}
