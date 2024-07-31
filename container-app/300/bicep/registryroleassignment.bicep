param acaenvironmentname string
param registryname string

var acrPullId = '7f951dda-4ed3-4680-a7ca-43fe172d538d'

resource acaenvironment 'Microsoft.App/managedEnvironments@2024-03-01' existing = {
  name: acaenvironmentname
}

resource registryresource 'Microsoft.ContainerRegistry/registries@2023-11-01-preview' existing = {
  name: registryname
}

//var functionIdentity  = reference(resourceId('Microsoft.Web/sites/',acaenvironment),'2020-12-01','full').identity.principalId

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2020-10-01-preview' = {
  scope: registryresource
  name: guid(resourceGroup().id,acaenvironmentname,acrPullId)
  properties: {
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions',acrPullId)
    principalId: acaenvironment.identity.principalId
    principalType: 'ServicePrincipal'
  }
}
