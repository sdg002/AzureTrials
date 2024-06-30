Experiments with container apps

# Step by step for attaching a new domain name to Azure Container app

[Refer this document](docs/dnszone.md)

# References

## Medium-Bicep template for Azure Container Environment
https://willvelida.medium.com/creating-and-provisioning-azure-container-apps-with-bicep-ebe83d733b02


##  Bicep reference for container apps
https://learn.microsoft.com/en-us/azure/templates/microsoft.app/containerapps?pivots=deployment-language-bicep

## Hello world image from Microsoft
https://mcr.microsoft.com/en-us/product/mcr/hello-world/about

## Nice youtube
https://www.youtube.com/watch?v=0Jb3RClw4jc

## How to registe a new domain using Azure DNS Zone ?
https://learn.microsoft.com/en-us/azure/dns/dns-delegate-domain-azure-dns


# What to do next ?
You were reading the Medium article.
- How to attach custom domain via Bicep 


# Managed domain - you were reading this
https://learn.microsoft.com/en-us/azure/container-apps/custom-domains-managed-certificates?pivots=azure-portal

# Action - upgrade Bicep

```

Command ran in 44.908 seconds (init: 0.692, invoke: 44.216)
Deploying container apps environment caedemosauuksouth001
A new Bicep release is available: v0.28.1. Upgrade now by running "az bicep upgrade".
C:\Users\saurabhd\MyTrials\AzureStuff\AzureTrials\AzureTrials\container-app\100\bicep\acaenvironment.bicep(5,31) : Warning BCP081: Resource type "Microsoft.OperationalInsights/workspaces@2023-09-01" does not have types available.
C:\Users\saurabhd\MyTrials\AzureStuff\AzureTrials\AzureTrials\container-app\100\bicep\acaenvironment.bicep(11,26) : Warning BCP081: Resource type "Microsoft.App/managedEnvironments@2024-03-01" does not have types available.
```

# Create a private Zone - Read this

https://learn.microsoft.com/en-us/azure/container-apps/waf-app-gateway?tabs=default-domain

# Create an App Service Domain
https://learn.microsoft.com/en-us/azure/app-service/manage-custom-dns-buy-domain


You were here
try tagging domain to container app
create bicep with domain
create bicep for Domain

```json
    consent: {
      agreedAt: '2024-06-26T21:17:22.5859535+01:00'
      agreedBy: 'saurabh'
    }

```

