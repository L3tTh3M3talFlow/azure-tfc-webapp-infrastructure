# Environment-specific variables for Development environment
resource_group_name = "RGCDS-DEV"
name_prefix         = "myapp-dev"
location            = "westus3"
environment         = "dev"
tags = {
  Environment = "dev"
  Project     = "Contoso Web App"
}

# App Service Settings
os_type                   = "Windows"
sku_name                  = "S1"
app_service_custom_domain = "graph.contosoazure.org"

# Storage account configuration
storage_replication = "LRS"
