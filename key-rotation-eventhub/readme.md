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
 - YOu created key vault

 # To be done
 - Create event hub via ARM
 - Add event hub secret
 - Rotation .PS1
 