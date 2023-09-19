
# Azure event hub key rotation solution

# Objective
?? talk about the problem, talk about key rotation
talk about C# code refreshing its secrets from key vault


# Remove the following (to be done)
```
Set-AzContext -Subscription "Pay-As-You-Go-demo"
```

# Minimum requirements for running the accompanying code (to be done)?

- PoweShell Core
- PowerShell cmdlets
- Visual Studio 2022
- Azure subscription (caveat on pricing)


# About the code (to be done)

## Structure of the code
Show a simple tree like structure of the code and explain what is what


## How to deploy the infrstructure ?
???

## Setting the Azure resource names in variables.ps1 (to be done)
Significance of one and only one `Variables.ps1` file

## Rotate the EventHub connection string and update the key vault

??

## Sampel C# code to fetch configuration from Key Vault
Explain the significance of 

---

# Essential commands and snippets

## Getting the Event hub connection string

```
Get-AzEventHubKey -Namespace $Global:EventHubNameSpace -ResourceGroupName $global:ResourceGroup -Name RootManageSharedAccessKey
```

```
$keys=Get-AzEventHubKey -Namespace $Global:EventHubNameSpace -ResourceGroupName $global:ResourceGroup -Name RootManageSharedAccessKey

You need to download latest Powershell cmdlets. Change of signature


# Adding to key vault via ARM template

```
    {
    "type": "Microsoft.KeyVault/vaults/secrets",
    "apiVersion": "2021-11-01-preview",
    "name": "[concat( parameters('keyVaultName'),'/', 'STORAGEACCOUNTKEY')]",
    "properties": {
        "value": "[listKeys(resourceId(resourceGroup().name,'Microsoft.Storage/storageAccounts/',parameters('storageAccountName')),'2022-09-01').keys[0].value]"
        }
    }

```

# Progress

 # Done
 - YOu created key vault

 # To be done
 - Create event hub via ARM
 - Add event hub secret
 - Rotation .PS1
 