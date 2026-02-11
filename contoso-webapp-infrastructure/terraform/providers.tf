provider "azurerm" {
  features {
    key_vault {
      purge_soft_deleted_secrets_on_destroy = false
      recover_soft_deleted_secrets          = true
    }
  }
}

data "azurerm_client_config" "current" {}
