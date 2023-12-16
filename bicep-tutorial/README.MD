[[_TOC_]]
# Overview
This is step by step basics of Bicep

# Next
1. Do complete deployment of Azure Function in the 105 folder
1. Rename 105 folder to 105-function-app-with-mounted-file-share
1. Create a variable to hold the mountpath


# 101-Deploy a simple storage account
???

# 102-Deploy Application insights and Log analytics workspace
???

# 104-Function App
To specify the Python version, you will need to specify the property `linuxFxVersion` under `siteConfig` to `Python|3.9`.
---

# Bicep function nuances

## Retrieving the storage account key
```
param storageaccount string
var storageaccountkey=listkeys(resourceId('Microsoft.Storage/storageAccounts/', storageaccount),'2021-02-01').keys[0].value
var storagecnstring='DefaultEndpointsProtocol=https;AccountName=${storageaccount};EndpointSuffix=${environment().suffixes.storage};AccountKey=${storageaccountkey}'

```

## Retrieving the Application Insights connection string

```
param appinsight string
var appinsightcnstring=reference(resourceId('Microsoft.Insights/components',appinsight),'2020-02-02').ConnectionString
```


---

# Snippets

## Create a Blob container in an existing Storage account
```
param storageaccount string
param container string

resource rStorageAccountContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-04-01' = {
  name: '${storageaccount}/default/${container}'
  properties: {}
}
```
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

https://github.com/Azure/bicep/discussions/8951

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

## Get a Storage account connection string

```
param storageaccount string
var storageaccountkey=listkeys(resourceId('Microsoft.Storage/storageAccounts/', storageaccount),'2021-02-01').keys[0].value

var storagecnstring='DefaultEndpointsProtocol=https;AccountName=${storageaccount};EndpointSuffix=${environment().suffixes.storage};AccountKey=${storageaccountkey}'

output mystorageaccountcnstring string=storagecnstring

```
---


# Setting up the local development environment for Azure functions

## Essential tools
1. **Azure Functions Core tools** should be installed (64-bit, Version 4)
1.  **VS Code** and **Azure Function** extension

## Debug locally
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

# Mount path inside Azure function

Once an Azure file share has been mounted to the Azure Function, the Azure function would see the following directory:

```
import os
...

files_in_share = os.listdir("/path/to/mount")
```

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
