[[_TOC_]]
# Overview
This is step by step basics of Bicep

# Next - REMOVE THIS WHEN DONE
1. network rules on key vault
1. network rules on storage account




# 101-Deploy a simple storage account

```
param location string = resourceGroup().location
param name string

resource storageaccount 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: name
  location: location
  tags: resourceGroup().tags
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
}

```

---

# 102-Deploy Application insights and Log analytics workspace

Refer folder [102-applicationinsights](102-applicationinsights)

---

# 104-Function App with Application Insights

## About

To specify the Python version, you will need to specify the property `linuxFxVersion` under `siteConfig` to `Python|3.9` of the functionapp bicep template.

Refer folder [104-function-app-with-appinsight](104-function-app-with-appinsight)


The Python Azure function app which logs to Application Insights using out of box `logging.info` statements

## How to test ?
- Deploy the Azure function (steps further below)
- Navigate to the Application Insights instance that got created and search for the `traces` table. You should the output from the `logging` getting captured

![function-logging-appinsight.png](docs/images/function-logging-appinsight.png)

---

# 105-Function App with Azure file share mounted (to be done)

## About 
Refer folder [105-function-app-with-mounted-fileshare](105-function-app-with-mounted-fileshare)

## How to test ?

[to be done]
Run the HttpTrigger2 , etc. etc.
[show picture to be shown of application insights and file share]

---

# 106-Function App with a Key Vault (to be done)

## Overview
In this exercise we deploy an instance of **Azure Key Vault** and then grant the function identity rights to read the secrets from this key vault. This requires that the Azure Function app has a system assigned identity. Therefore, run the **deploy.ps1** under **103-function-app** folder first.

Refer folder [106-function-app-with-keyvault-and-function-managed-identity](106-function-app-with-keyvault-and-function-managed-identity)


## How to test ?

1. You will need to write a Http trigger which reads a key vault given the key
1. Show evidence via a picture

---

# 108-Firewall settings on a Storage Account

## Azure Storage Explorer would not let you browse the contents
If you have restricted access to your firewall to 1 or more IP addresses, then Azure will not let you browse the contents of the Containers from other IP addresses. Example below:

![storage-browser-after-firewall-applied](docs/images/storage-browser-after-firewall-applied.png)

## Azure Cloud Shell should not work either

` az storage blob list --account-name stosaudemofirewalldev --container-name mydemocontainer001` 

## Where was I ?
- You introduced VNET for outbound function app traffic.
- 103 - Add a container and read/write to it from a new Timer trigger (No firewall)
    - 103-add a container to `FunctionStorageAccount` (no need for a new storage account, use `stdemoservice`)
    - 103-add a Write a Python trigger which writes and reads a Blob container and outputs via `logging.info`
    - 103-Test that the trigger works when no fire wall settings are applied. Expected - Should work
- 108-Apply firewall on storage account. **Expected** - Should fail
- Do the following together
    - 108-Add vnet to allow list
    - 108-Add VNET to function app 
    - Expected - Should work
- Finish the Bicep

```
The request may be blocked by network rules of storage account. Please check network rule set using 'az storage account show -n accountname --query networkRuleSet'.
If you want to change the default action to apply when no rule matches, please use 'az storage account update'.
```

---


# 109-Cosmos ( to be done)

## Overview
In this example we are deploying an instance of Cosmos. **To be done**. Add the cn string to key vault

## How to test ?

Show picture of Key vault with cosmos connection string

---

# Snippets

## Retrieving the storage account key

```
param storageaccount string
var storageaccountkey=listkeys(resourceId('Microsoft.Storage/storageAccounts/', storageaccount),'2021-02-01').keys[0].value
var storagecnstring='DefaultEndpointsProtocol=https;AccountName=${storageaccount};EndpointSuffix=${environment().suffixes.storage};AccountKey=${storageaccountkey}'

```

---

## Retrieving the Application Insights connection string

```
param appinsight string
var appinsightcnstring=reference(resourceId('Microsoft.Insights/components',appinsight),'2020-02-02').ConnectionString
```


---


## Create a Blob container in an existing Storage account

### When the bicep is only deploying a Container ?
```
param storageaccount string
param container string

resource rStorageAccountContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-04-01' = {
  name: '${storageaccount}/default/${container}'
  properties: {}
}

```

### When the bicep is deploying both the storage account and the Blob container ?

If the bicep is deploying both the storage account and the Blob container(s) then the `dependsOn` field should be used to define the sequence of execution. Otherwise, your deployment is likely to fail.


```
param location string = resourceGroup().location
param name string

resource storageaccount 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: name
  location: location
  tags: resourceGroup().tags
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
}

resource symbolicName1 'Microsoft.Storage/storageAccounts/blobServices/containers@2022-09-01' = {
  name: '${name}/default/mydemocontainer001'
  dependsOn: [storageaccount]
  properties: {
    defaultEncryptionScope: '$account-encryption-key'
    denyEncryptionScopeOverride: false
    publicAccess: 'None'
  }
}
```


---

## Create an Azure file share in an existing Storage account

```
param storageaccount string
param share string

resource myShare2 'Microsoft.Storage/storageAccounts/fileServices/shares@2022-09-01' = {
  name: '${storageaccount}/default/${share}'
  properties: {}
}

```

## Simple example of output values

Simplest possible output 
```
param myparam string
output myparm string=myparam

```

You can see the element by the name `myparam` under the top level `outputs` node.

```json
{
  "id": "/subscriptions/12345678-1234-43ac-1234-123467e1abfe/resourceGroups/RG-BICEP-DEMO-001/providers/Microsoft.Resources/deployments/outputs",
  "location": null,
  "name": "outputs",
  "properties": {
    "correlationId": "12345678-1234-1234-1234-c7f4c8ea33c6",
    "debugSetting": null,
    "dependencies": [],
    "duration": "PT1.064109S",
    "error": null,
    "mode": "Incremental",
    "onErrorDeployment": null,
    "outputResources": [],
    "outputs": {
      "myparm": {
        "type": "String",
        "value": "value for my param"
      }
    },
    "parameters": {
      "myparam": {
        "type": "String",
        "value": "value for my param"
      }
    },
    "parametersLink": null,
    "providers": [],
    "provisioningState": "Succeeded",
    "templateHash": "9639229030702551116",
    "templateLink": null,
    "timestamp": "2023-12-15T22:47:50.964464+00:00",
    "validatedResources": null
  },
  "resourceGroup": "RG-BICEP-DEMO-001",
  "tags": null,
  "type": "Microsoft.Resources/deployments"
}
```

## Get a reference to Cosmos connection string

Refer this [Github thread](https://github.com/Azure/bicep/discussions/8951) for more insight

```
param cosmosaccount string
var mong_cn_string =listConnectionStrings(resourceId('Microsoft.DocumentDB/databaseAccounts/',cosmosaccount),'2023-11-15').connectionStrings[0].connectionString

output mongo string = mong_cn_string

param cosmosaccount string
var mong_cn_string=listConnectionStrings(resourceId('Microsoft.DocumentDB/databaseAccounts/',mongodatabaseaccount),'2023-11-15').connectionStrings[0].connectionString
*/
```

You should see the connection string emitted under the `outputs` node 

```json
{
    .
    .
    .
   "outputs": {
      "mongo": {
        "type": "String",
        "value": "mongodb://cosmon-demo-dev:YOURSECRETCONNECTIONKEY==@cosmon-demo-dev.mongo.cosmos.azure.com:10255/?ssl=true&replicaSet=globaldb&retrywrites=false&maxIdleTimeMS=120000&appName=@cosmon-demo-dev@"
      },
      "myparm": {
        "type": "String",
        "value": "value for my param"
      }
    }
    .
    .
    .
}
```
---

## Get a Storage account connection string

```
param storageaccount string
var storageaccountkey=listkeys(resourceId('Microsoft.Storage/storageAccounts/', storageaccount),'2021-02-01').keys[0].value

var storagecnstring='DefaultEndpointsProtocol=https;AccountName=${storageaccount};EndpointSuffix=${environment().suffixes.storage};AccountKey=${storageaccountkey}'

output mystorageaccountcnstring string=storagecnstring

```
---

# Azure function-Setting up the local development environment and deploying

## Essential tools
1. **Azure Functions Core tools** should be installed (64-bit, Version 4)
1.  **VS Code** and **Azure Function** extension

## Debug locally
1. Ensure you have done a `az login` and followed by `az account set --name <YOUR_SUBSCRIPTION_NAME>` (if you have multiple subscriptins)
1. Launch the folder `src-python-function` in **VS Code**  
1. The accompanying source has a simple timer trigger
1. You should be able to debug by pressing **F5**


## Deploying your function code to Azure

- Ensure that you have created the infrastructure on Azure by executing the deploy script under 104 folder 
- Run the following command to deploy your local code to Azure

```powershell
func azure functionapp publish <name of the function app> --python
```
Do not be tempted to use **--force** parameter

----

# Mount path inside Azure function (TO BE DONE, improve this, provide app settings)

Once an Azure file share has been mounted to the Azure Function, the Azure function would see the following directory:

```
import os
...

files_in_share = os.listdir("/path/to/mount")
```

---
# Using the Complete mode when deploying Bicep
The `mode` parameter is interesting and very powerful. The default value is `incremental`. In the following example - if you were run this command with mode set to `Complete` in a stand alone way, then all prior resources **will be deleted** in the resource group.

```powershell
Write-Host "Adding secrets to the key vault $Global:KeyVault"
& az deployment group create --resource-group $Global:ResourceGroup `
    --template-file "$PSScriptRoot\templates\keyvaultsecrets.bicep" `
    --parameters `
    keyvaultname=$Global:KeyVault `
    storageaccount=$Global:FunctionStorageAccount `
    --verbose --mode Complete

```

---


# Reference

## VS Code quick start - Microsoft link
https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/quickstart-create-bicep-use-visual-studio-code?tabs=CLI#add-parameter

## Error deploying bicep files
```
https://github.com/Azure/bicep/issues/2364
```
https://github.com/Azure/bicep/issues/2364

## Azure Bicep template reference for File Shares
https://learn.microsoft.com/en-us/azure/templates/microsoft.storage/2022-09-01/storageaccounts/fileservices?pivots=deployment-language-bicep


## Using Azure Cli to mount a file share
https://learn.microsoft.com/en-us/azure/azure-functions/scripts/functions-cli-mount-files-storage-linux


## Getting a reference to Cosmos connection string
https://github.com/Azure/bicep/discussions/8951

## Complete mode and Incremental mode
https://learn.microsoft.com/en-us/azure/azure-resource-manager/templates/deployment-modes#complete-mode
