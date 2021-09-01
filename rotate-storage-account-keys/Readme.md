# To be done
# Create infra PS
- Create resource group
- Create key vault
- Create storage account
- Add permissions to read key vault
- Add identities
- Try reading some keys

# Create rotation PS
- Read from CSV , name of storage account, resource group, name of Key vault key name
- Get keys of storage account
- Compare with Key vault and find matching keys
- Rotate the key not in key vault
- Add new key to key vault

# Misc
```
$keys=Get-AzStorageAccountKey -ResourceGroupName $ResourceGroup -Name $DemoAccountName
# Gives Key1
$keys[0].KeyName  
# Gives Value
$keys[0].Value

```

