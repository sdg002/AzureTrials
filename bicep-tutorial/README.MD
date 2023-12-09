[[_TOC_]]
# Overview
This is step by step basics of Bicep

# Next
1. Deploy the Azure function and test if it is logging
1. Deploy file share
1. Mount file share
1. Assign permissoin of function managed identity to file share 


# 101-Deploy a simple storage account
???

# 102-Deploy Application insights and Log analytics workspace
???

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


# Working with Python Azure function

1. Ensure you have the **VS Code** and **Azure Function** extension
1. Launch the folder `src-python-function` in **VS Code**  
1. The accompanying source has a simple timer trigger
1. You should be able to debug by pressing **F5**

----

# Reference

## VS Code quick start - Microsoft link
https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/quickstart-create-bicep-use-visual-studio-code?tabs=CLI#add-parameter

## Error deploying bicep files
```
https://github.com/Azure/bicep/issues/2364
```
https://github.com/Azure/bicep/issues/2364
