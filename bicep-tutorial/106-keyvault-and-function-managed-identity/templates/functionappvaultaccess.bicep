param functionapp string
param keyvaultname string


@description('This is the built-in Key Vault User role. See https://docs.microsoft.com/azure/role-based-access-control/built-in-roles#contributor')
resource keyVaultSecretUserRoleDefinition 'Microsoft.Authorization/roleDefinitions@2018-01-01-preview' existing = {
  scope: subscription()
  name: '4633458b-17de-408a-b874-0445c86b69e6'
}

resource myKeyVault 'Microsoft.KeyVault/vaults@2019-09-01' existing= {
  name: keyvaultname
  scope:resourceGroup()
}


var functionIdentity  = reference(resourceId('Microsoft.Web/sites/',functionapp),'2020-12-01','full').identity.principalId


resource roleAssignment 'Microsoft.Authorization/roleAssignments@2020-10-01-preview' = {
  scope: myKeyVault
  name: guid(resourceGroup().id,functionapp,keyVaultSecretUserRoleDefinition.id)
  properties: {
    roleDefinitionId: keyVaultSecretUserRoleDefinition.id
    principalId: functionIdentity
    principalType: 'ServicePrincipal'
  }
}
