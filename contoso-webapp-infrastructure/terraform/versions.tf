terraform {
  required_version = "~> 1.6"

  cloud {
    organization = "contosoazureorg"
    workspaces {
      name = "cds-dev-webapp-infra"
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
