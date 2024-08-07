[[_TOC_]]

# Experiments with container apps


# Overview

![resourcegroup.png](docs/ppt-images/resourcegroup.png)

---

# 100-Container Environment

In this exercise:
1. Create an instance of Azure Container Environment (via Bicep)
1. Assign a managed identityt to the Azure Container Environment (will be used for simplifiyng image pull in subsequent steps)
1. Creaet an instance of Log Analytics (via Bicep)
1. Click [here](100-containerenvironment) to browse the files in this folder
1. Click on [deploy.ps1](100-containerenvironment/deploy.ps1) to deploy the resources

---

# 200-Webapp

1. Create an Azure Container App with a well known image  (via Bicep)
1. We are not yet creating our own images at this stage
1. Click [here](200-webapp) to browse the files in this folder

---

# 300-Registry
1. Create an instance of Azure Container Registry
1. Add the system and user assigned identity of the Azure Container Environment to the AcrPull RBAC role of the Azure Container Registry,  so that images can be pulled without the need for login and password

# 400-Job
1. How to do a local docker build
1. Link to [sample Python source code](sample-job-app/)
1. Attention - In practice, there would be a CI/CD pipeline that would be responsible for Docker build and push operations. For this exercise please refer to the following scripts:
1. How to initiate a Docker build ? Run the script [buildimage.ps1](400-job/buildimage.ps1)
1. How to push the local Docker image to Azure Container Registry? Run the script [buildimage.ps1](400-job/pushimage.ps1)

---


# 500-Step by step for creating and attaching a new domain name to Azure Container app

In this exercise:

1. Create an instance of DNS Zone (via Bicep). This is the top level domain (example: contoso.com)
1. Create an instance of App Service Domain (via Bicep)
1. [Refer this document for the manual steps](docs/dnszone.md)
1. Manually create the CNAME and TXT records in the DNS Zone  (example: myapp.contoso.com)
1. Manually add the new domain (myapp.contoso.com) to the Container app of Lab 200
1. Click [here](500-dnszone) to see the folder files.
1. Click on `deploy.ps1` to deploy the resources

---

# 300 - Creating an ACR and deploying a Job

https://learn.microsoft.com/en-us/cli/azure/containerapp/job?view=azure-cli-latest#az-containerapp-job-create

## How to create a managed identity ?

```
resource acaManagedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: "name_of_the_identity"
  location: location
  tags: resourceGroup().tags
}
```

## Permissions needed by Container app on ACR

This is a critical configuration without which the container app cannot pull the specified image from the Azure Container Registry. The managed identity of the 

```
var acrPullId = '7f951dda-4ed3-4680-a7ca-43fe172d538d'

resource roleAssignmentContainerEnvironmentManagedIdentityAcrPull 'Microsoft.Authorization/roleAssignments@2020-10-01-preview' = {
  scope: registryresource
  name: guid(resourceGroup().id,acaidentity.name,acrPullId)
  properties: {
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions',acrPullId)
    principalId: acaidentity.properties.principalId
    principalType: 'ServicePrincipal'
  }
}

```
## How to assign a managed identity ?

You will need to have an identity reference as shown below:
```
  identity: {
    type:'SystemAssigned, UserAssigned'
    userAssignedIdentities:{
      '${acaManagedIdentity.id}': {}
    }
  }

```
---

# Lessons learnt

## When locks are applied

You are likely to ecounter this error while trying to delete objects connected to DNS zone. Refer error messages in [locks.md](docs/locks.md)

## System identity does not work well when ACA tries an ACR pull

See role assignment in [300-registry](300-registry)

## When using system assigned identity, bicep deployment with acr pull fails 
https://github.com/microsoft/azure-container-apps/issues/836

---

# References

##  Microsoft-Bicep reference for container apps
This is the source of truth for any Bicep. But examples are often lacking
https://learn.microsoft.com/en-us/azure/templates/microsoft.app/containerapps?pivots=deployment-language-bicep

## Medium-Bicep template for Azure Container Environment
A short and sweet example with biceps
https://willvelida.medium.com/creating-and-provisioning-azure-container-apps-with-bicep-ebe83d733b02

## Hello world image from Microsoft
https://mcr.microsoft.com/en-us/product/mcr/hello-world/about


## How to register a new domain using Azure DNS Zone ?
https://learn.microsoft.com/en-us/azure/dns/dns-delegate-domain-azure-dns

---


## Workload profile types
https://learn.microsoft.com/en-us/azure/container-apps/workload-profiles-overview

Look at the table of possible values. The Consumption type must have the name Consumption

## Container-registry role assignment
https://stackoverflow.com/questions/74413085/how-do-i-configure-my-bicep-scripts-to-allow-a-container-app-to-pull-an-image-fr

## Azure built in role ids
We need to use these guids to when we want to do a role assignment to any built in role. E.g. ACA should be in AcrPull role of the registry
https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles
Refer 7f951dda-4ed3-4680-a7ca-43fe172d538d for AcrPull


## Example of assigning managed identity
https://larry.claman.net/post/2021-08-19-21-bicep-uami/



## Managed domain 
https://learn.microsoft.com/en-us/azure/container-apps/custom-domains-managed-certificates?pivots=azure-portal


## Create a private Zone
https://learn.microsoft.com/en-us/azure/container-apps/waf-app-gateway?tabs=default-domain

---

## Create an App Service Domain
https://learn.microsoft.com/en-us/azure/app-service/manage-custom-dns-buy-domain


## Nice Youtube video on Azure Front Door on top of Azure Container Apps
https://www.youtube.com/watch?v=0Jb3RClw4jc

## Nice Youtube video on Azure Application Gateway on top of Azure Container Apps
With lots of Bicep templates explained. See Bicep viewer in VS Code
https://www.youtube.com/watch?v=WLIU18WF77c

---


# Next steps
    1.How to start the Job and disply the logs on the Console (via az)
    1. Explain how to monitor
    1. KQL queries    
    1. Explain the table
    1. How to use Bicep Viewer in VS Code
