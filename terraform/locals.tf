locals {
  key_vault_name = lower("${var.name_prefix}-kv-${random_string.kv_suffix.result}")
  key_vault_app_settings = {
    DbPassword = "@Microsoft.KeyVault(SecretUri=${module.key_vault.vault_uri}secrets/DbPassword)"
  }
  # Example name_prefix: "myapp-dev"
  # Storage rule: lowercase letters/numbers only, 3-24 chars, globally unique
  storage_prefix_clean = lower(replace(var.name_prefix, "-", ""))

  # Reserve space for "sa" + suffix (2 + 6 = 8 chars)
  storage_prefix_trimmed = substr(local.storage_prefix_clean, 0, 24 - 8)

  storage_account_name = "${local.storage_prefix_trimmed}sa${random_string.storage_suffix.result}"
}