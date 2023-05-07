[[_TOC_]]

# About this article
I have presented a simple step by step hands on guide to understand Azure ARM templates. There is a widely held belief that Azure ARM templates are terribly complicated and thus there is a need for 3rd party solutions. It my humble hope that at the end of this hands on guide I will be able to convince you otherwise.

---

# Prerequisites
- VS Code with ARM extensions installed
- PowerShell Core
- Azure CLI installed and signed in
- An Azure subscription

The philosopy of this guide is to "_use Microsoft's Azure CLI tool and Microsoft's PowerShell and Microsoft's VS Code to take control of Microsoft Azure Cloud_" . No need to use any 3rd party tools.

![vscode_arm_template_extension.png](docs/images/vscode_arm_template_extension.png)

---

# Structure of this Guide
to be done
[???talk about the folder structure, prep folder, how to run each of the scripts]

```
    -100-prep-create-resource-group
        |
        |--deploy.ps1
        |
    -200-arm-structure
        |
        |--deploy.ps1
        |
        |--arm.json
        |
    -common
        |
        |--variables.ps1
        |

```


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

# 301-Deploy a storage account using just the Azure CLI and set the tags (no ARM template)

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

# 302-How to grab an ARM template of an Azure resource using the Azure portal

Head over the Azure portal and browse to any resource group. Select New resource [??? Improve this line with a picture for better context]

## Page 1-[???]
![portal-storage-account-create-001](docs/images/portal-storage-account-create-001.png)

## Page 2-[???]
![portal-storage-account-create-001](docs/images/portal-storage-account-create-002.png)

## Page 3-[???]
![portal-storage-account-create-001](docs/images/portal-storage-account-create-003.png)

## Page 4-[???]
![portal-storage-account-create-001](docs/images/portal-storage-account-create-004.png)

## Page 5-[???]
![portal-storage-account-create-001](docs/images/portal-storage-account-template-download.png)


## Understanding the ARM template
[show the parameters, explain some of them, give references to thers ??]


---

# 303-Deploy a storage account using an ARM template (using a parameters file)

All the parameters are specified in the file **parameters.json**. Notice a slight quirk here. The path to the parameter file should be prefixed with the **@** symbol. This is because there are multiple ways to pass parameters when deploying ARM templates via the **Azure CLI**.

```powershell
$armTemplateFile=Join-Path -Path $PSScriptRoot -ChildPath "template.json"
$armParameterFile=Join-Path -Path $PSScriptRoot -ChildPath "parameters.json"

Write-Host "Going to create a storage account '$Global:StorageAccount' using ARM template $armTemplateFile"
& az deployment group create --resource-group $Global:ResourceGroup --template-file $armTemplateFile --parameters @$armParameterFile --verbose

```
---

# 304-Deploy a storage account using an ARM template (location and name as explicit parameters)
We are still using a parameters file but overriding the **storageAccountName** and **location**.  This could be a very useful feature. Consider a scenario where a singe parameter file could serve as a template for all storage accounts involved in your application deployment.


```powershell
$armTemplateFile=Join-Path -Path $PSScriptRoot -ChildPath "template.json"
$armParameterFile=Join-Path -Path $PSScriptRoot -ChildPath "parameters.json"


& az deployment group create --resource-group $Global:ResourceGroup --template-file $armTemplateFile `
    --parameters @$armParameterFile location=westeurope  storageAccountName=section304 `
    --verbose
```
---
# 305-Deploy a storage account using an ARM template (tags referenced from an external JSON file )

In this exercise we want to set the tags of our storage account with name-values stored in an external JSON file.

## Step 1 - New parameter in the ARM template
We define a new parameter in the ARM template which has a type of `object`:

```json
{
"parameters": {
    "tags":{
        "type" : "object"
        }
    }
}
        
```

## Step 2 - New JSON file to store the tags

We create a new file with tags information in JSON format:

```json
{
    "department" :"finance",
    "costcenter": "eusales",
    "owner":"janedoe@cool.com"
}
```

## Step 3 - Instruct Azure CLI to use the tags JSON file

And finally pass the file name as a named parameter to the `Azure CLI`:

```powershell
$armTemplateFile=Join-Path -Path $PSScriptRoot -ChildPath "template.json"
$armParameterFile=Join-Path -Path $PSScriptRoot -ChildPath "parameters.json"
$tagsJsonFile=Join-Path -Path $PSScriptRoot -ChildPath "tags.json"

Write-Host "Going to create a storage account '$Global:StorageAccount' using ARM template $armTemplateFile"
& az deployment group create --resource-group $Global:ResourceGroup --template-file $armTemplateFile `
    --parameters @$armParameterFile storageAccountName=section305 `
    tags=@$tagsJsonFile `
    --verbose
```

---

# 306-Deploy a storage account using an ARM template (location and tags borrowed from the parent resource group)
We know now how to override the parameters of an ARM template. In most of the situations Azure resources might share the same **location** and **tags** as the parent resource group. If I have several resources to deploy in the same resource group then I will have to pass the location and tags for each and every one of them. Can we simplify our code by eliminating this repetition ? This is where built in ARM template functions come in handy.

## The resourceGroup() ARM function

The ARM template is now referencing the `tags` and `location` from the parent resource group

```json
"tags": "[resourceGroup().tags]"
```

```json
"location": "[resourceGroup().location]"
```

## Simplification of the ARM template
The parameters block in the ARM json no longer has the `tags` and `location` elements

## Simplification of the Azure CLI invocation
The `Azure CLI` invocation no longer needs the `location` and `tags` parameters to be supllied explicitly

```powershell
& az deployment group create --resource-group $Global:ResourceGroup --template-file $armTemplateFile `
    --parameters @$armParameterFile storageAccountName=section306 `
    --verbose

```
## ARM template functions reference
https://learn.microsoft.com/en-us/azure/azure-resource-manager/templates/template-functions

---
# 307- Deploy a storage account using an ARM template and output the storage keys
We know how to deploy a storage account. But, we would need the account keys for any downstream application to be able to make a connection (not strictly neccessary if using managed identity). This is where the ARM outputs are useful. 

## The output element

```json
    "outputs": {
        "primaryEndPoints": {
            "type": "object",
            "value":  "[reference(parameters('storageAccountName')).primaryEndPoints]"
          },
        "accountKey": {
            "type": "string",
            "value":  "[listKeys(variables('resourceId'),'2022-09-01').keys[0].value]"
          }        

    }

```

## Result of deployment
```json
    "outputs": {
      "accountKey": {
        "type": "String",
        "value": "WE2RBZqF7EAiY+VO9Es3aQqy9yJrul7svRiwji1oaccNcVWRrF0LYn2cJ1H77B13WKx/Rb02yafb+AStdyK4pA=="
      },
      "primaryEndPoints": {
        "type": "Object",
        "value": {
          "blob": "https://section307.blob.core.windows.net/",
          "dfs": "https://section307.dfs.core.windows.net/",
          "file": "https://section307.file.core.windows.net/",
          "queue": "https://section307.queue.core.windows.net/",
          "table": "https://section307.table.core.windows.net/",
          "web": "https://section307.z33.web.core.windows.net/"
        }
      }
    }
```

## Reference
https://devkimchi.com/2018/01/05/list-of-access-keys-from-output-values-after-arm-template-deployment/

---

# 400- Deploy a key vault using an ARM template

In this example we will deploy an **Azure Key Vault** resource using ARM template. Like beore, I used the Azure portal to generate a skeletal ARM template for me. I removed the `location` and `tenantid` parameters and replaced these with calls to ARM functions.

```json
"location": "[resourceGroup().location]"
```

```json
"tenantId": "[tenant().tenantId]"
```

```powershell
& az deployment group create --resource-group $Global:ResourceGroup --template-file $armTemplateFile `
    --parameters @$armParameterFile `
    name=saudemovault400 `
    --verbose
```
---

# your progress is here
- ~~create a storage account with explicit location and tags using the Azure CLI~~
- ~~ARM-Storage-use the location and tags from resource group~~
- ~~ARM-Storage-output the storage key (Very important! Does it even work!)~~
- ~~ARM-Storage-use custom tags from a JSON file~~
- ARM-create a key vault 
- ARM how to add secrets to Key vault YOU WERE HERE
- ARM-can we add the storage key directly to the key vault 
- App service plan
- Web app - Flask  
    - simple form to save document to storage account
    - simple form to read from storage account
    - Create App service plan
    - Create web app, pass app settings, raw environment value
    - Create web app, pass app settings, key vault reference
- ??
---

# References
## Azure ARM template reference
https://learn.microsoft.com/en-us/azure/azure-resource-manager/templates/syntax

## Azure ARM template - defining new functions
https://learn.microsoft.com/en-us/azure/azure-resource-manager/templates/syntax#functions

## ARM template functions reference
https://learn.microsoft.com/en-us/azure/azure-resource-manager/templates/template-functions

---
## How to use listkeys in an ARM template ?
https://devkimchi.com/2018/01/05/list-of-access-keys-from-output-values-after-arm-template-deployment/
