
@description('Generated from /subscriptions/635a2074-cc31-43ac-bebe-2bcd67e1abfe/resourceGroups/rg-demo-container-apps-dev-uks/providers/Microsoft.DomainRegistration/domains/sau001.com')
resource saucom 'Microsoft.DomainRegistration/domains@2023-12-01' = {
  name: 'sau001.com'
  location: 'global'
  tags: {
    costcenter: 'hello cost'
  }
  properties: {
    registrationStatus: 'Active'
    provisioningState: 'Succeeded'
    nameServers: [
      'ns1-33.azure-dns.com'
      'ns2-33.azure-dns.net'
      'ns3-33.azure-dns.org'
      'ns4-33.azure-dns.info'
    ]
    privacy: true
    createdTime: '2024-06-26T01:57:15'
    expirationTime: '2025-06-26T01:57:15'
    autoRenew: false
    readyForDnsRecordManagement: true
    managedHostNames: []
    domainNotRenewableReasons: [
      'ExpirationNotInRenewalTimeRange'
    ]
    dnsType: 'AzureDns'
    dnsZoneId: '/subscriptions/635a2074-cc31-43ac-bebe-2bcd67e1abfe/resourcegroups/rg-demo-container-apps-dev-uks/providers/Microsoft.Network/dnszones/sau001.com'
    isSoftDeleted: false
  }
}
