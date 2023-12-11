param location string = resourceGroup().location
param name string




resource keyVault 'Microsoft.KeyVault/vaults@2019-09-01' = {
  name: name
  location: location
  tags:resourceGroup().tags
  properties: {
    enabledForDeployment: true
    enabledForTemplateDeployment: true
    enabledForDiskEncryption: true
    tenantId: subscription().tenantId
    enableRbacAuthorization: true
    enableSoftDelete:true
    publicNetworkAccess : true
    softDeleteRetentionInDays: 8
    accessPolicies: []
    sku: {
      name: 'standard'
      family: 'A'
    }
  }
}
