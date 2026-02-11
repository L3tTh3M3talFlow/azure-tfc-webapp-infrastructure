# High-level orchestration (module calls, providers)
module "resource_group" {
  source  = "app.terraform.io/contosoazureorg/resource-group/azurerm"
  version = "1.0.0"

  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

module "log_analytics_workspace" {
  source  = "app.terraform.io/contosoazureorg/log-analytics-workspace/azurerm"
  version = "1.0.0"

  name                = "${var.name_prefix}-law"
  location            = var.location
  resource_group_name = module.resource_group.name
  tags                = var.tags
}

module "application_insights" {
  source  = "app.terraform.io/contosoazureorg/application-insights/azurerm"
  version = "1.0.0"

  name                = "${var.name_prefix}-ai"
  location            = var.location
  resource_group_name = module.resource_group.name
  workspace_id        = module.log_analytics_workspace.id
  tags                = var.tags

  depends_on = [module.log_analytics_workspace]
}

module "app_service_plan" {
  source  = "app.terraform.io/contosoazureorg/app-service-plan/azurerm"
  version = "1.0.0"

  name                = "${var.name_prefix}-asp"
  location            = var.location
  resource_group_name = module.resource_group.name

  os_type  = var.os_type
  sku_name = var.sku_name

  tags = var.tags
}

module "app_service" {
  for_each = var.enable_app_service ? { web = {} } : {}
  source   = "app.terraform.io/contosoazureorg/app-service/azurerm"
  version  = "1.0.0"

  name                = "${var.name_prefix}-web"
  location            = var.location
  resource_group_name = module.resource_group.name
  service_plan_id     = module.app_service_plan.id
  os_type             = var.os_type
  tags                = var.tags

  app_settings = merge(
    module.key_vault.app_settings,
    {
      APPLICATIONINSIGHTS_CONNECTION_STRING = module.application_insights.connection_string
      ASPNETCORE_ENVIRONMENT                = "Development"
    }
  )

  depends_on = [module.key_vault]
}

resource "random_string" "kv_suffix" {
  length  = 5
  upper   = false
  special = false
}

module "key_vault" {
  source  = "app.terraform.io/contosoazureorg/key-vault/azurerm"
  version = "1.0.0"

  name                = local.key_vault_name
  location            = var.location
  resource_group_name = module.resource_group.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
}

resource "azurerm_role_assignment" "terraform_kv_secrets_officer" {
  scope                = module.key_vault.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = data.azurerm_client_config.current.object_id
}

resource "azurerm_key_vault_secret" "db_password" {
  name         = "DbPassword"
  value        = var.db_password
  key_vault_id = module.key_vault.id

  depends_on = [azurerm_role_assignment.terraform_kv_secrets_officer]
}

resource "random_string" "storage_suffix" {
  length  = 6
  upper   = false
  special = false
}

module "storage_account" {
  source  = "app.terraform.io/contosoazureorg/storage-account/azurerm"
  version = "1.0.0"

  name                = local.storage_account_name
  location            = var.location
  tags                = var.tags
  resource_group_name = module.resource_group.name

  account_replication_type = var.storage_replication
}
