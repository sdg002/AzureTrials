param keyvaultname string
param storageaccount string
var storageaccountkey=listkeys(resourceId('Microsoft.Storage/storageAccounts/', storageaccount),'2021-02-01').keys[0].value

resource keyVaultSecret1 'Microsoft.KeyVault/vaults/secrets@2019-09-01' = {
  name: '${keyvaultname}/functionappstorageaccountkey'
  properties: {
    value: storageaccountkey
  }
}

resource keyVaultSecret2 'Microsoft.KeyVault/vaults/secrets@2019-09-01' = {
  name: '${keyvaultname}/mysecretname001'
  properties: {
    value: 'mysecretvalue001'
  }
}
