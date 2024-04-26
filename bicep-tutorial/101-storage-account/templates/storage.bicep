param location string = resourceGroup().location
param name string

resource storageaccount 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: name
  location: location
  tags: resourceGroup().tags
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
}


resource symbolicName1 'Microsoft.Storage/storageAccounts/blobServices/containers@2022-09-01' = {
  name: '${name}/default/mycontainer9001'
  properties: {
    defaultEncryptionScope: '$account-encryption-key'
    denyEncryptionScopeOverride: false
    publicAccess: 'None'
  }
}

resource symbolicName2 'Microsoft.Storage/storageAccounts/blobServices/containers@2022-09-01' = {
  name: '${name}/default/mycontainer9002'
  properties: {
    defaultEncryptionScope: '$account-encryption-key'
    denyEncryptionScopeOverride: false
    publicAccess: 'None'
  }
}
