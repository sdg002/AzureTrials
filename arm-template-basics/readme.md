[[_TOC_]]

# About this article
I have presented a simple step by step hands on guide to understand Azure ARM templates. There is a widely held belief that Azure ARM templates are terribly complicated and thus there is a need for 3rd party solutions. It my humble hope that at the end of this hands on guide I will be able to convince you otherwise

---

# Prerequisites
- VS Code with ARM extensions installed
- PowerShell Core
- Azure CLI installed and signed in
- An Azure subscription

![vscode_arm_template_extension.png](docs/images/vscode_arm_template_extension.png)

---

# Structure of this Guide
to be done
[???talk about the folder structure, prep folder, how to run each of the scripts]


---

# 100-Prepping the resource group

We will need a resource group to contain all the Azure resources we create. For this guide we will confine oursleves to a one and only resource group. 

## Creating a basic resource group using the Azure CLI
This is one of the simplest CLI commands
```powershell
& az group create --location $Global:Location --name $Global:ResourceGroup
```

## Creating a resource group using the Azure CLI with tags

Having tags is essential in an enterprise environment. This facilicates the central IT to get a birds eye view  of the dozens/hundreds of applications
```powershell
& az group create --location $Global:Location --name $Global:ResourceGroup --tags department=finance owner=johndoe@cool.com costcenter=eusales
```

![resource-group-tags.png](docs/images/resource-group-tags.png)

---

# 200-Basic ARM template structure

**VS Code** enhances the editing experience of ARM templates. 
- Create a new file . Example. **arm.json**
- Type the key word **arm** and you should see the intellisense popping up. Select the option **arm!**
![vscode-arm-code-snippet.png](docs/images/vscode-arm-code-snippet.png)

this is a functioning ARM template. Let us try and deploy this ARM template by using the Azure CLI

## Command
```powershell
az deployment group create --resource-group $Global:ResourceGroup --template-file $armFilePath  --verbose
```

## What to expect when deploy an ARM template ?
```json
{
  "id": "/subscriptions/635a2074-cc31-43ac-bebe-2bcd67e1abfe/resourceGroups/rg-demo-arm-template-experiments/providers/Microsoft.Resources/deployments/arm",
  "location": null,
  "name": "arm",
  "properties": {
    "correlationId": "191c43f7-8126-4b37-9a9b-b553084db85f",
    "debugSetting": null,
    "dependencies": [],
    "duration": "PT0.2946402S",
    "error": null,
    "mode": "Incremental",
    "onErrorDeployment": null,
    "outputResources": [],
    "outputs": {},
    "parameters": {},
    "parametersLink": null,
    "providers": [],
    "provisioningState": "Succeeded",
    "templateHash": "11635883502557795404",
    "templateLink": null,
    "timestamp": "2023-04-30T22:46:12.610885+00:00",
    "validatedResources": null
  },
  "resourceGroup": "rg-demo-arm-template-experiments",
  "tags": null,
  "type": "Microsoft.Resources/deployments"
}
```

## Understanding the structure of ARM
At the very root every ARM template has the 5 elements: **parameters**, **functions**, **variables**, **resources** and **outputs**
```json
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {},  //The inputs to the ARM. E.g. Location, Name of the resource , etc. could be passed as parameters
    "functions": [], //Custom functions built out of the of box ARM functions
    "variables": {}, //Additional variables. E.g. you could create a variable that holds a calculated value and is referenced multiple times
    "resources": [], //The actual Azure resources that are geting created
    "outputs": {} //These are values that are programmed to be returned back. These values can be used for subsequent operations. 
}
```

When we deployed our skeletal ARM template, the elements **outputResources** and **outputs** are empty because the elements **resources** and **outputs** of the input ARM file were empty.

---
# 300-Deploy a storage account using just the Azure CLI (no ARM template)

Creating a Storage account is very simple. Just 1 call to the Azure CLI and you are done. No need for an ARM template

```powershell
& az storage account create --resource-group $Global:ResourceGroup --name $Global:StorageAccount --location $Global:Location --sku $Global:StorageAccountSku
```


![300-storage-account-using-cli-only.png](docs/images/300-storage-account-using-cli-only.png)

---

# 301-Deploy a storage account using just the Azure CLI and set the tags(no ARM template)

In this example we using the `--tags` option of the Azure CLI to apply the tags on our Storage account. We are not yet using an ARM template.

```powershell
& az storage account create --resource-group $Global:ResourceGroup --name $Global:StorageAccount `
    --location $Global:Location --sku $Global:StorageAccountSku `
    --tags department=$Global:TagDepartment owner=$Global:TagOwner costcenter=$Global:TagCostCenter

```

Notice that we are referencing the same **Global** variables that were used during the resource group creation.

![301-storage-account-using-cli-only-with-tags](docs/images/301-storage-account-using-cli-only-with-tags.png)

So why bother using ARM templates if Azure CLI does it for you. In the broader picture, using ARM templates can simplify the overall CI/CD by removing redundant parameters and redundant calls to Azure CLI. 

---

# 302-Deploy a storage account using an ARM template

## Step 1-How to grab the ARM template from the Azure portal ?
[Show the steps with picutres, parameter names, could use Git repository]

## Step 2-Tidy up the ARM template
[remove unwanted parameters, etc.]

## Step 3-Deploy the ARM template
[pass location as parameter, explain how to grab the ARM template]

---
# 302-Deploy a storage account using an ARM template (location and tags as parameters)
[Extend the pevious ARM template and pass the location and  ]

---

# 303-Deploy a storage account using an ARM template (location and tags borrowed referenced from resource group)
[Extend the pevious ARM template and pass the location and  ]

---

# you were here
- create a storage account with explicit location and tags using the Azure CLI
- use the location from resource group
- use the tags from resource group
- output the storage key
- create a key vault
- can we add the storage key directly to the key vault
---

# References
## Azure ARM template reference
https://learn.microsoft.com/en-us/azure/azure-resource-manager/templates/syntax

## Azure ARM template - defining new functions
https://learn.microsoft.com/en-us/azure/azure-resource-manager/templates/syntax#functions

---
