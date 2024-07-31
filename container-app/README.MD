[[_TOC_]]
Experiments with container apps

---

# 100 - Create Azure Container Environment and Container App via Bicep

In this exercise:
1. Create an instance of Azure Container Environment (via Bicep)
1. Creaet an instance of Log Analytics (via Bicep)
1. Create an Azure Container App with a well known image  (via Bicep)
1. Click [here](100) to see the folder files.
1. Click on `deploy.ps1` to deploy the resources

---

# 200-Step by step for creating and attaching a new domain name to Azure Container app

In this exercise:

1. Create an instance of DNS Zone (via Bicep). This is the top level domain (example: contoso.com)
1. Create an instance of App Service Domain (via Bicep)
1. [Refer this document for the manual steps](docs/dnszone.md)
1. Manually create the CNAME and TXT records in the DNS Zone  (example: myapp.contoso.com)
1. Manually add the new domain (myapp.contoso.com) to the Container app of Lab 100
1. Click [here](200) to see the folder files.
1. Click on `deploy.ps1` to deploy the resources

---

# 300 - Creating an ACR and deploying a Job

https://learn.microsoft.com/en-us/cli/azure/containerapp/job?view=azure-cli-latest#az-containerapp-job-create

## Workload profile types
https://learn.microsoft.com/en-us/azure/container-apps/workload-profiles-overview

Look at the table of possible values. The Consumption type must have the name Consumption

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

---

# What to do next ?
- Create a custom Python Flask app
- Deploy to custom Azure Custom registry
- How do you push this image to an existing Azure Container App
- Create a long running job
- Deploy a web app and a long running job. Make the job interact to the web app via REST.

---

# References

## Managed domain 
https://learn.microsoft.com/en-us/azure/container-apps/custom-domains-managed-certificates?pivots=azure-portal



## Create a private Zone

https://learn.microsoft.com/en-us/azure/container-apps/waf-app-gateway?tabs=default-domain

---

## Create an App Service Domain
https://learn.microsoft.com/en-us/azure/app-service/manage-custom-dns-buy-domain


