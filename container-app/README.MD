[[_TOC_]]
Experiments with container apps

---

# 100 - Create Azure Container Environment and Container App via Bicep

In this exercise:
1. Create an instance of Azure Container Environment (via Bicep)
1. Creaet an instance of Log Analytics (via Bicep)
1. Create an Azure Container App with a well known image  (via Bicep)
1. Click [here](100) to see the folder files.

---

# 200-Step by step for creating and attaching a new domain name to Azure Container app

In this exercise:

1. Create an instance of DNS Zone (via Bicep). This is the top level domain (example: contoso.com)
1. Create an instance of App Service Domain (via Bicep)
1. [Refer this document for the manual steps](docs/dnszone.md)
1. Manually create the CNAME and TXT records in the DNS Zone  (example: myapp.contoso.com)
1. Manually add the new domain (myapp.contoso.com) to the Container app of Lab 100
1. Click [here](200) to see the folder files.

---

# References

## Medium-Bicep template for Azure Container Environment
https://willvelida.medium.com/creating-and-provisioning-azure-container-apps-with-bicep-ebe83d733b02


##  Bicep reference for container apps
https://learn.microsoft.com/en-us/azure/templates/microsoft.app/containerapps?pivots=deployment-language-bicep

## Hello world image from Microsoft
https://mcr.microsoft.com/en-us/product/mcr/hello-world/about

## Nice Youtube video
https://www.youtube.com/watch?v=0Jb3RClw4jc

## How to register a new domain using Azure DNS Zone ?
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


# Remove this section or tidy it up!
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

