
@description('Generated from /subscriptions/635a2074-cc31-43ac-bebe-2bcd67e1abfe/resourceGroups/rg-demo-container-apps-dev-uks/providers/Microsoft.App/managedEnvironments/lala-environment')
resource lalaenvironment 'Microsoft.App/managedEnvironments@2024-03-01' = {
  name: 'lala-environment'
  location: 'UK 
  systemData: {
    createdBy: 'saurabh_dasgupta@hotmail.com'
    createdByType: 'User'
    createdAt: '2024-06-23T18:24:23.3538986'
    lastModifiedBy: 'saurabh_dasgupta@hotmail.com'
    lastModifiedByType: 'User'
    lastModifiedAt: '2024-06-23T18:24:23.3538986'
  }
  properties: {
    provisioningState: 'Succeeded'
    daprAIInstrumentationKey: null
    daprAIConnectionString: null
    vnetConfiguration: null
    defaultDomain: 'ashysky-bce57404.uksouth.azurecontainerapps.io'
    staticIp: '4.158.58.15'
    appLogsConfiguration: {
      destination: 'log-analytics'
      logAnalyticsConfiguration: {
        customerId: '8c16a8bb-76f6-4e79-a106-c82100bd167b'
        sharedKey: null
      }
    }
    zoneRedundant: false
    kedaConfiguration: {
      version: '2.14.0'
    }
    daprConfiguration: {
      version: '1.12.5'
    }
    eventStreamEndpoint: 'https://uksouth.azurecontainerapps.dev/subscriptions/635a2074-cc31-43ac-bebe-2bcd67e1abfe/resourceGroups/rg-demo-container-apps-dev-uks/managedEnvironments/lala-environment/eventstream'
    customDomainConfiguration: {
      customDomainVerificationId: '85CFBE3C419174E53D3F4F4EFCE4ABD0E363F4096DD33290351AA8E63A0956D0'
      dnsSuffix: null
      certificateValue: null
      certificatePassword: null
      thumbprint: null
      subjectName: null
      expirationDate: null
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
