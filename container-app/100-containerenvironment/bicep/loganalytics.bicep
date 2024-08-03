param location string = resourceGroup().location
param name string

@description('Generated from /subscriptions/635a2074-cc31-43ac-bebe-2bcd67e1abfe/resourceGroups/rg-demo-container-apps-dev-uks/providers/microsoft.operationalinsights/workspaces/workspacergdemocontainerappsdevuks8076')
resource workspacergdemocontainerappsdevuks 'Microsoft.OperationalInsights/workspaces@2023-09-01' = {
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: 30
    features: {
      legacy: 0
      searchVersion: 1
      enableLogAccessUsingOnlyResourcePermissions: true
    }
    workspaceCapping: {
      dailyQuotaGb: json('-1.0')
    }
    publicNetworkAccessForIngestion: 'Enabled'
    publicNetworkAccessForQuery: 'Enabled'
  }
  location: location
  name: name
}
