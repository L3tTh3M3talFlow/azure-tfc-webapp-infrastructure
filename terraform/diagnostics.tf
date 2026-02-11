# -----------------------------------
# Storage account root → metrics only
# -----------------------------------
module "storage_account_metrics" {
  source = "app.terraform.io/contosoazureorg/diagnostic-settings/azurerm"

  name                       = "diag-storage-metrics"
  target_resource_id         = module.storage_account.id
  log_analytics_workspace_id = module.log_analytics_workspace.id

  metric_categories = [
    "Transaction"
  ]
}

# --------------------------------------
# Blob service ID (constructed manually)
# --------------------------------------
locals {
  storage_blob_service_id = "${module.storage_account.id}/blobServices/default"
}

# -----------------------------------------
# Blob service → auth + read/write failures
# -----------------------------------------
module "storage_blob_diagnostics" {
  source = "app.terraform.io/contosoazureorg/diagnostic-settings/azurerm"

  name                       = "diag-storage-blob"
  target_resource_id         = local.storage_blob_service_id
  log_analytics_workspace_id = module.log_analytics_workspace.id

  log_categories = [
    "StorageRead",
    "StorageWrite",
    "StorageDelete"
  ]
}

# --------------------------
# Key Vault → audit failures
# --------------------------
module "key_vault_diagnostics" {
  source = "app.terraform.io/contosoazureorg/diagnostic-settings/azurerm"

  name                       = "diag-key-vault"
  target_resource_id         = module.key_vault.id
  log_analytics_workspace_id = module.log_analytics_workspace.id

  log_categories = [
    "AuditEvent"
  ]
}
