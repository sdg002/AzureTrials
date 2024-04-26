param location string = resourceGroup().location
param name string
param planname string
param storageaccount string
param appinsight string
var storageaccountkey=listkeys(resourceId('Microsoft.Storage/storageAccounts/', storageaccount),'2021-02-01').keys[0].value
var storagecnstring='DefaultEndpointsProtocol=https;AccountName=${storageaccount};EndpointSuffix=${environment().suffixes.storage};AccountKey=${storageaccountkey}'
var appinsightcnstring=reference(resourceId('Microsoft.Insights/components',appinsight),'2020-02-02').ConnectionString


resource azureFunction 'Microsoft.Web/sites@2020-12-01' = {
  name: name
  location: location
  kind: 'functionapp'
  tags: resourceGroup().tags
  properties: {    
    serverFarmId: resourceId('Microsoft.Web/serverfarms',planname)
    siteConfig: {
      use32BitWorkerProcess: false
      ftpsState:'FtpsOnly'
      linuxFxVersion:'Python|3.9'
      alwaysOn:true
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
        {
          name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
          value: appinsightcnstring
        }
        {
          name: 'MOUNTEDSHARENAME'
          value: '/hello123'
        }      ]
    }
  }
}
