# Environment-specific variables for Development environment
resource_group_name = "YOURNAMEHERE-DEV"
name_prefix         = "yourapp-dev"
location            = "westus3"
environment         = "dev"
tags = {
  Environment = "dev"
  Project     = "Contoso Web App"
}

# App Service Settings
os_type                   = "Windows"
sku_name                  = "S1"
app_service_custom_domain = "your.customdomain.tld"

# Storage account configuration
storage_replication = "LRS"

