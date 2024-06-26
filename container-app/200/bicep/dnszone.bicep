param name string

@description('Generated from /subscriptions/635a2074-cc31-43ac-bebe-2bcd67e1abfe/resourceGroups/rg-demo-container-apps-dev-uks/providers/Microsoft.Network/dnszones/sau001.com')
resource saucom 'Microsoft.Network/dnsZones@2023-07-01-preview' = {
  name: name
  location: 'global'
  tags: {}
  properties: {
    zoneType: 'Public'
  }
}
