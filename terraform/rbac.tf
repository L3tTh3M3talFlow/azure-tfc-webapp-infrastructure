resource "azurerm_role_assignment" "app_service_kv_secrets_user" {
  for_each             = module.app_service
  scope                = module.key_vault.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = each.value.principal_id
}

resource "azurerm_role_assignment" "app_service_storage_blob_contributor" {
  scope                = module.storage_account.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = one(values(module.app_service)).principal_id

  depends_on = [
    module.app_service,
    module.storage_account
  ]
}
