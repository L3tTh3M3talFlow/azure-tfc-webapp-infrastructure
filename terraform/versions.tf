terraform {
  required_version = "~> 1.6" # Terraform client version

  cloud {
    organization = "your org name"
    workspaces {
      name = "your TFC workspace"
    }
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 3.0.0" # Pin to a specific version for stability
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}
