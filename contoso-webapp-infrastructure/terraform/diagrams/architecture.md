# Architecture

```mermaid
flowchart TD
    DevOps[Azure DevOps Pipeline]
    TFC[Terraform Cloud]
    Azure[(Azure Subscription)]

    DevOps --> TFC
    TFC --> Azure

    subgraph Azure
        Web[App Service]
        KV[Key Vault]
        SA[Storage Account]
        LAW[Log Analytics]

        Web --> KV
        Web --> SA
        KV --> LAW
        SA --> LAW
    end
```
