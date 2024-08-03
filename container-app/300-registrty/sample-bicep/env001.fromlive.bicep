
@description('Generated from /subscriptions/635a2074-cc31-43ac-bebe-2bcd67e1abfe/resourceGroups/rg-demo-container-apps-dev-uks/providers/Microsoft.App/managedEnvironments/caedemosauuksouth001')
resource caedemosauuksouth 'Microsoft.App/managedEnvironments@2024-03-01' = {
  name: 'caedemosauuksouth001'
  location: 'UK South'
  systemData: {
    createdBy: 'saurabh_dasgupta@hotmail.com'
    createdByType: 'User'
    createdAt: '2024-07-30T19:41:53.411933'
    lastModifiedBy: 'saurabh_dasgupta@hotmail.com'
    lastModifiedByType: 'User'
    lastModifiedAt: '2024-07-30T20:39:02.5270393'
  }
  properties: {
    provisioningState: 'Succeeded'
    daprAIInstrumentationKey: null
    daprAIConnectionString: null
    vnetConfiguration: null
    defaultDomain: 'jollydesert-bcf39b73.uksouth.azurecontainerapps.io'
    staticIp: '85.210.120.104'
    appLogsConfiguration: {
      destination: 'log-analytics'
      logAnalyticsConfiguration: {
        customerId: 'a3f908b5-7af4-495b-acc2-c01f1fe28630'
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
    eventStreamEndpoint: 'https://uksouth.azurecontainerapps.dev/subscriptions/635a2074-cc31-43ac-bebe-2bcd67e1abfe/resourceGroups/rg-demo-container-apps-dev-uks/managedEnvironments/caedemosauuksouth001/eventstream'
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
