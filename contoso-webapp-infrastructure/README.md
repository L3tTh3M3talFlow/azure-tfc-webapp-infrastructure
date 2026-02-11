# Azure Web App Infrastructure (Terraform)

## Overview
This repository provisions a standardized Azure web application infrastructure using Terraform, Terraform Cloud, and Azure DevOps.  
It implements an identity‑first, RBAC‑driven design with centralized diagnostics and approval‑gated deployments.

## What This Deploys
- Resource Group
- Log Analytics Workspace
- Application Insights
- App Service Plan
- App Service (with system‑assigned managed identity)
- Azure Key Vault
- Azure Storage Account
- Diagnostics for Key Vault and Storage access failures
- RBAC permissions for App Service → Key Vault and Storage

All infrastructure is deployed via Azure DevOps pipelines and Terraform Cloud.

## Architecture
The App Service uses a managed identity to access:
- Key Vault secrets
- Storage blobs

Diagnostics are routed to Log Analytics to capture:
- Key Vault denied operations
- Storage authorization failures

## Terraform Cloud
Terraform Cloud is used for:

- Remote state storage
- State locking
- Audit trail of runs
- Execution runs
- Workspace separation per environment

------------------------------------------------------------------------

## Workspaces

Each environment maps to a Terraform Cloud workspace.

**Example:**

    cds-dev-webapp-infra

------------------------------------------------------------------------

## Required Workspace Variables

These variables are configured **in Terraform Cloud**, not in this
repository:

  Variable              Description
  --------------------- -----------------------------------
  ARM_CLIENT_ID         Azure service principal client ID
  ARM_CLIENT_SECRET     Azure service principal secret
  ARM_SUBSCRIPTION_ID   Azure subscription ID
  ARM_TENANT_ID         Azure tenant ID

All sensitive values must be marked **Sensitive**.

------------------------------------------------------------------------

## Azure DevOps Pipeline

Infrastructure is deployed using an Azure DevOps YAML pipeline.

### Variable Groups

The pipeline references a variable group for Terraform Cloud
authentication:

-   **Variable Group:** `terraform-cloud`
-   **Variable:** `TFC_TOKEN` (Terraform Cloud API token)

The token is injected into the pipeline as the environment variable:

    TF_TOKEN_app_terraform_io

No secrets are stored in the repository.

------------------------------------------------------------------------

## How the Pipeline Works

1.  Pipeline is triggered from the `dev` branch only when Terraform files change
2.  Terraform CLI is installed on the build agent
3.  `terraform init` runs using Terraform Cloud
4.  `terraform plan` is executed
5.  `terraform apply` provisions Azure resources

Terraform execution occurs remotely in Terraform Cloud.

------------------------------------------------------------------------

## Diagnostics
Enabled for:
- Key Vault (AuditEvent)
- Storage blob service (read/write/delete with auth failures)
- Storage metrics

All logs flow to Log Analytics for troubleshooting.

------------------------------------------------------------------------

## Running Terraform Locally (Optional)

Local execution is supported for development and troubleshooting only.

### Prerequisites

-   Terraform CLI installed
-   Terraform Cloud API token
-   Azure service principal credentials

### Example

``` bash
export TF_TOKEN_app_terraform_io=<terraform_cloud_token>

terraform init -var-file=env/dev.tfvars
terraform plan -var-file=env/dev.tfvars
```

> Production deployments must always go through the Azure DevOps
> pipeline.

------------------------------------------------------------------------

## Environments

Each environment (dev / test / prod) should have:

-   Its own Terraform Cloud workspace
-   Its own Azure resource group
-   Its own variable values

Environment promotion is handled through pipeline controls, not
Terraform logic.

------------------------------------------------------------------------

## Design Principles

-   Infrastructure is immutable
-   Terraform state is never stored locally
-   No environment-specific logic inside modules
-   All changes are reviewed via pull requests
-   Terraform Cloud is the source of truth

------------------------------------------------------------------------

## Common Operations

### Add a New Resource

1.  Update `main.tf`
2.  Run `terraform plan` via the pipeline
3.  Review the output
4.  Merge and apply

### Rotate Secrets

-   Rotate the secret in Azure AD / Azure
-   Update Terraform Cloud workspace variables
-   Re-run the pipeline

No code changes required.

------------------------------------------------------------------------

## What This Repository Does Not Do

-   Deploy application code
-   Manage application configuration
-   Create Azure AD identities (beyond service principals)
-   Handle autoscaling or runtime operations

Those concerns live elsewhere.

------------------------------------------------------------------------

## Ownership & Support

This repository is owned by the **Platform / DevOps team**.

Infrastructure changes should be:

-   Intentional
-   Reviewed
-   Logged via Terraform Cloud

If something breaks, check the Terraform Cloud run logs first. They're
usually right.

------------------------------------------------------------------------

## Final Notes

If you're tempted to:

-   Click around in the Azure Portal
-   Hotfix infrastructure manually
-   Bypass the pipeline

Don't.

That's how drift happens.

Commit the change, let Terraform do its job, and move on.
