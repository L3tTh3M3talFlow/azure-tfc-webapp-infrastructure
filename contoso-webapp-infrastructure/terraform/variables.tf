### Terraform Variables for Contoso Web App Infrastructure
variable "location" {
  description = "Azure region"
  type        = string
}

variable "name_prefix" {
  description = "Prefix for naming resources"
  type        = string
}

variable "tags" {
  description = "Tags applied to the resource group"
  type        = map(string)
  default     = {}
}

### Additional variables for Resource Group
variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

### Additional variables for App Service
variable "os_type" {
  description = "Operating system type (Linux or Windows)"
  type        = string
}

variable "sku_name" {
  description = "SKU name (e.g. P1v3, S1, B1)"
  type        = string
}

variable "app_service_custom_domain" {
  description = "Fully qualified custom domain (DNS) name for the App Service"
  type        = string
}

variable "enable_app_service" {
  type    = bool
  default = true
}

### Additional variables for Key Vault and database credentials
variable "db_password" {
  type      = string
  sensitive = true
}

### Storage account configuration
variable "storage_replication" {
  description = "Storage account replication type (e.g. LRS, GRS)"
  type        = string
}
