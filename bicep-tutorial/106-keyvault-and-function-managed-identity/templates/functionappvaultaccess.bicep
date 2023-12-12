param functionapp string
param keyvaultname string



resource myKeyVault 'Microsoft.KeyVault/vaults@2019-09-01' existing= {
  name: keyvaultname
  scope:resourceGroup()
}

/*
The roleDefinitionId field of the resource roleAssignments can be supplied in any of the following ways:

Option 1
---------
Declare the following 
@description('This is the built-in Key Vault User role. See https://docs.microsoft.com/azure/role-based-access-control/built-in-roles#contributor')
resource keyVaultSecretUserRoleDefinition 'Microsoft.Authorization/roleDefinitions@2018-01-01-preview' existing = {
  scope: subscription()
  name: '4633458b-17de-408a-b874-0445c86b69e6'
}
roleDefinitionId: keyVaultSecretUserRoleDefinition.id

Option 2
--------
Access the role definition directly - no need for declaring keyVaultSecretUserRoleDefinition
roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions','4633458b-17de-408a-b874-0445c86b69e6')
*/

var functionIdentity  = reference(resourceId('Microsoft.Web/sites/',functionapp),'2020-12-01','full').identity.principalId
var kvRoleDefinitionId = resourceId('Microsoft.Authorization/roleDefinitions','4633458b-17de-408a-b874-0445c86b69e6')

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2020-10-01-preview' = {
  scope: myKeyVault
  name: guid(resourceGroup().id,functionapp,kvRoleDefinitionId)
  properties: {
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions','4633458b-17de-408a-b874-0445c86b69e6')
    principalId: functionIdentity
    principalType: 'ServicePrincipal'
  }
}
