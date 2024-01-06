
@minLength(3)
param storageaccount string

@minLength(3)
param name string

var resourceName='${storageaccount}/default/${name}'

resource storageContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2023-01-01' = {
  name: resourceName
}
