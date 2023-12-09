param location string = resourceGroup().location
param name string
param planname string
param storageaccount string
var storagecnstring='DefaultEndpointsProtocol=https;AccountName=stosaudemodev0123;AccountKey=s4nfuqKrRALInrLooZwmYl4u7Cfy8Jh8RR6MwsgT3ZWyrqdapcc7Fb5JLIr0SJL9JTXoD+J+J0cf+AStVlfBKQ==;EndpointSuffix=core.windows.net'

//'DefaultEndpointsProtocol=https;AccountName=${storageaccount};EndpointSuffix=${environment().suffixes.storage};AccountKey=${storageAccount.listKeys().keys[0].value}'


//'DefaultEndpointsProtocol=https;AccountName=${storageaccount};AccountKey=${listKeys('storageAccountID2', '2019-06-01').key1}'
/*
'DefaultEndpointsProtocol=https;AccountName=storageAccountName2;AccountKey=${listKeys('storageAccountID2', '2019-06-01').key1}'
*/

resource azureFunction 'Microsoft.Web/sites@2020-12-01' = {
  name: name
  location: location
  kind: 'functionapp'
  tags: resourceGroup().tags
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
