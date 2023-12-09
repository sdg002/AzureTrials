param functionapp string
param mountPath string
param azureShareName string
param storageaccount string

var storageaccountkey=listkeys(resourceId('Microsoft.Storage/storageAccounts/', storageaccount),'2021-02-01').keys[0].value

resource storageSetting 'Microsoft.Web/sites/config@2021-01-15' = {
  name: '${functionapp}/azurestorageaccounts'
  properties: {
    'mydemofileshare-id': {
      type: 'AzureFiles'
      shareName: azureShareName
      mountPath: mountPath
      accountName: storageaccount
      accessKey: storageaccount
    }
  }
}

//https://stackoverflow.com/a/69150741/2989655
