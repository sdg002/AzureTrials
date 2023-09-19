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
