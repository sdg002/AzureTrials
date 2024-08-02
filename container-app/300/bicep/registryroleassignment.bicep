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

resource roleAssignmentContainerEnvironmentSystemIdentityAcrPull 'Microsoft.Authorization/roleAssignments@2020-10-01-preview' = {
  scope: registryresource
  name: guid(resourceGroup().id,acaenvironmentname,acrPullId)
  properties: {
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions',acrPullId)
    principalId: acaenvironment.identity.principalId
    principalType: 'ServicePrincipal'
  }
}

resource acaidentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: 'caedemosauuksouth001identity'
  location:resourceGroup().location
}

resource roleAssignmentContainerEnvironmentManagedIdentityAcrPull 'Microsoft.Authorization/roleAssignments@2020-10-01-preview' = {
  scope: registryresource
  name: guid(resourceGroup().id,acaidentity.name,acrPullId)
  properties: {
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions',acrPullId)
    principalId: acaidentity.properties.principalId
    principalType: 'ServicePrincipal'
  }
}

