to be done

```
Set-AzContext -Subscription "Pay-As-You-Go-demo"
```

```
Get-AzEventHubKey -Namespace $Global:EventHubNameSpace -ResourceGroupName $global:ResourceGroup -Name RootManageSharedAccessKey
```

# Getting the primary connection string
```
$keys=Get-AzEventHubKey -Namespace $Global:EventHubNameSpace -ResourceGroupName $global:ResourceGroup -Name RootManageSharedAccessKey

Write-Host $keys.PrimaryConnectionString
```


# Regenerate the key

You were reading this 
https://learn.microsoft.com/en-us/powershell/module/az.eventhub/new-azeventhubkey?view=azps-10.3.0#examples

```
New-AzEventHubKey -Namespace $Global:EventHubNameSpace -ResourceGroupName $global:ResourceGroup -Name RootManageSharedAccessKey -KeyType PrimaryKey
```

```
New-AzEventHubKey -Namespace $Global:EventHubNameSpace -ResourceGroupName $global:ResourceGroup -Name RootManageSharedAccessKey -KeyType SecondaryKey
```

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
- You created key vault
- Create event hub via ARM
- Add event hub secret
 
 # To be done
- Rotation .PS1
- C# code to poll Key Vault (IConfiguration) and demonstrate that the value changes

---

# Rotate.ps1

```
.\rotate.ps1 -rg $Global:ResourceGroup -eventhub $Global:EventHubNameSpace -keyvault $Global:KeyVault -secret "eventhubcnstring"
```

--- 

# References

## Stack Overflow 
https://stackoverflow.com/questions/51320268/arm-get-eventhub-namespace-shareacesspolicykey


## MS guidance on accessing Event Hub connection strings
https://github.com/pascalnaber/EnterpriseARMTemplates/blob/6babc4d3e65f10f999bb144a1d616ccb2a085e9d/templates/resources/Microsoft.Eventhub/azuredeploy.json


## MS Guidance on Key rotation solution using Azure function
https://learn.microsoft.com/en-us/azure/key-vault/secrets/tutorial-rotation-dual?tabs=azure-cli


## MS Sample Azure function code to automate the secret rotation
https://github.com/Azure-Samples/KeyVault-Rotation-StorageAccountKey-PowerShell

## MS Article on fetching secrets from C# (not using IConfiguration)
https://learn.microsoft.com/en-us/azure/key-vault/general/tutorial-net-create-vault-azure-web-app

## MS Article on fetching secrets from C# (using IConfiguration approach)
https://learn.microsoft.com/en-us/aspnet/core/security/key-vault-configuration?view=aspnetcore-7.0



---
