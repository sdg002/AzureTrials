
@description('Generated from /subscriptions/635a2074-cc31-43ac-bebe-2bcd67e1abfe/resourceGroups/rg-demo-container-apps-dev-uks/providers/Microsoft.App/managedEnvironments/lalaa01123')
resource lalaa 'Microsoft.App/managedEnvironments@2024-03-01' = {
  name: 'lalaa01123'
  location: 'UK South'
  systemData: {
    createdBy: 'saurabh_dasgupta@hotmail.com'
    createdByType: 'User'
    createdAt: '2024-08-08T16:55:02.0765076'
    lastModifiedBy: 'saurabh_dasgupta@hotmail.com'
    lastModifiedByType: 'User'
    lastModifiedAt: '2024-08-08T16:55:02.0765076'
  }
  properties: {
    provisioningState: 'Succeeded'
    daprAIInstrumentationKey: null
    daprAIConnectionString: null
    vnetConfiguration: {
      internal: true
      infrastructureSubnetId: '/subscriptions/635a2074-cc31-43ac-bebe-2bcd67e1abfe/resourceGroups/rg-demo-container-apps-dev-uks/providers/Microsoft.Network/virtualNetworks/vnetdev001/subnets/newsubnetportal001'
      dockerBridgeCidr: null
      platformReservedCidr: null
      platformReservedDnsIP: null
    }
    defaultDomain: 'happysmoke-bb9fd193.uksouth.azurecontainerapps.io'
    staticIp: '10.0.7.172'
    appLogsConfiguration: {
      destination: null
      logAnalyticsConfiguration: null
    }
    zoneRedundant: false
    kedaConfiguration: {
      version: '2.14.0'
    }
    daprConfiguration: {
      version: '1.12.5'
    }
    eventStreamEndpoint: 'https://uksouth.azurecontainerapps.dev/subscriptions/635a2074-cc31-43ac-bebe-2bcd67e1abfe/resourceGroups/rg-demo-container-apps-dev-uks/managedEnvironments/lalaa01123/eventstream'
    customDomainConfiguration: {
      customDomainVerificationId: '85CFBE3C419174E53D3F4F4EFCE4ABD0E363F4096DD33290351AA8E63A0956D0'
      dnsSuffix: null
      certificateValue: null
      certificatePassword: null
      thumbprint: null
      subjectName: null
      expirationDate: null
    }
    workloadProfiles: [
      {
        workloadProfileType: 'Consumption'
        name: 'Consumption'
      }
    ]
    infrastructureResourceGroup: 'ME_lalaa01123_rg-demo-container-apps-dev-uks_uksouth'
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
