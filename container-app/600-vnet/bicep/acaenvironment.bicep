param location string = resourceGroup().location
param name string
param logworkspacename string
param identityname string
param vnetname string

var subnet  = 'subnetcontainerenv'

resource logworkspaceresource 'Microsoft.OperationalInsights/workspaces@2023-09-01' existing = {
  name: logworkspacename
}

resource vnet 'Microsoft.Network/virtualNetworks@2024-01-01' existing = {
  name:vnetname
}
resource subnet001 'Microsoft.Network/virtualNetworks/subnets@2023-11-01' existing = {
  name: subnet
  parent:vnet
}

@description('Generated from /subscriptions/635a2074-cc31-43ac-bebe-2bcd67e1abfe/resourceGroups/rg-demo-container-apps-dev-uks/providers/Microsoft.App/managedEnvironments/lala-environment')
resource lalaenvironment 'Microsoft.App/managedEnvironments@2024-03-01' = {
  name: name
  location: location
  tags: resourceGroup().tags
  identity: {
    type:'SystemAssigned, UserAssigned'
    userAssignedIdentities:{
      '${acaManagedIdentity.id}': {}
    }
  }
  properties: {
    daprAIInstrumentationKey: null
    daprAIConnectionString: null
    vnetConfiguration: {
      internal:true
      infrastructureSubnetId: subnet001.id
      }
    appLogsConfiguration: {
      
      destination: 'log-analytics'
      logAnalyticsConfiguration: {
        customerId: logworkspaceresource.properties.customerId
        sharedKey: logworkspaceresource.listKeys().primarySharedKey
      }
    }
    zoneRedundant: false
    customDomainConfiguration: {
      dnsSuffix: null
      certificateValue: null
      certificatePassword: null
    }
    workloadProfiles: [

]
    infrastructureResourceGroup: null
    peerAuthentication: {
      mtls: {
        enabled: false
      }
    }
    peerTrafficConfiguration: {
      encryption: {
        enabled: false
      }
    }
  }
}

resource acaManagedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: identityname
  location: location
  tags: resourceGroup().tags
}
