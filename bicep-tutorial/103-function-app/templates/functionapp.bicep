param location string = resourceGroup().location
param name string
param planname string
param storageaccount string
var storageaccountkey=listkeys(resourceId('Microsoft.Storage/storageAccounts/', storageaccount),'2021-02-01').keys[0].value
var storagecnstring='DefaultEndpointsProtocol=https;AccountName=${storageaccount};EndpointSuffix=${environment().suffixes.storage};AccountKey=${storageaccountkey}'



resource azureFunction 'Microsoft.Web/sites@2020-12-01' = {
  name: name
  location: location
  kind: 'functionapp'
  tags: resourceGroup().tags
  identity:{
    type:'SystemAssigned'
  }
  properties: {
    serverFarmId: resourceId('Microsoft.Web/serverfarms',planname)
    siteConfig: {
      appSettings: [
        {
          name: 'AzureWebJobsStorage'
          value: storagecnstring
        }
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~4'
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: 'python'
        }
      ]
    }
  }
}
