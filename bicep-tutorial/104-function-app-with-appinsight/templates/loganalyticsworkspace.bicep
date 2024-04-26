param location string = resourceGroup().location
param name string

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2020-10-01' = {
  name: name
  location: location
  tags: resourceGroup().tags
  properties: {
    sku: {
      name: 'pergb2018'
    }
  }
}
