param location string = resourceGroup().location
param name string
param logworkspace string

resource appInsightsComponents 'Microsoft.Insights/components@2020-02-02' = {
  name: name
  location: location
  kind: 'web'
  tags: resourceGroup().tags
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId: resourceId('Microsoft.OperationalInsights/workspaces',logworkspace)
  }
}
