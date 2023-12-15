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


resource symbolicname 'Microsoft.Storage/storageAccounts/blobServices/containers@2022-09-01' = {
  name: '${name}/default/mycontainer9001'
  properties: {
    defaultEncryptionScope: 'Default'
    denyEncryptionScopeOverride: false
    publicAccess: 'None'
  }
}
