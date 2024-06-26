param location string = resourceGroup().location
param name string
param logworkspacename string

resource logworkspaceresource 'Microsoft.OperationalInsights/workspaces@2023-09-01' existing = {
  name: logworkspacename
}


@description('Generated from /subscriptions/635a2074-cc31-43ac-bebe-2bcd67e1abfe/resourceGroups/rg-demo-container-apps-dev-uks/providers/Microsoft.App/managedEnvironments/lala-environment')
resource lalaenvironment 'Microsoft.App/managedEnvironments@2024-03-01' = {
  name: name
  location: location
  properties: {
    daprAIInstrumentationKey: null
    daprAIConnectionString: null
    vnetConfiguration: null
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
    workloadProfiles: null
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
