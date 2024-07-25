param name string
param dnszonename string

resource dnszone 'Microsoft.Network/dnsZones@2023-07-01-preview' existing = {
  name: dnszonename
}

var email = 'saurabh_dasgupta@hotmail.com'
var nameFirst = 'saurabh'
var nameLast = 'dasgupta'
var nameMiddle = ''
var phone = '+44.0752201583'
var address = {
  address1:'33 Kings Wharf'
  address2: 'That Street'
  city:'London'
  country:'GB'
  postalCode:'RG13WE'
  state:'Berkshire'
}

@description('Generated from /subscriptions/635a2074-cc31-43ac-bebe-2bcd67e1abfe/resourceGroups/rg-demo-container-apps-dev-uks/providers/Microsoft.DomainRegistration/domains/sau001.com')
resource saucom 'Microsoft.DomainRegistration/domains@2023-12-01' = {
  name: name
  location: 'global'
  tags: {
    costcenter: 'hello cost'
  }
  properties: {
    contactAdmin:{
      email: email
      nameFirst:nameFirst
      nameLast:nameLast
      phone: phone
      addressMailing: address
    }
    contactBilling:{
      email: email
      nameFirst:nameFirst
      nameLast:nameLast
      phone: phone
      addressMailing: address
    }
    contactRegistrant:{
      email: email
      nameFirst:nameFirst
      nameLast:nameLast
      phone:phone
      addressMailing: address
    }
    contactTech:{
      email: email
      nameFirst:nameFirst
      nameLast:nameLast
      phone:phone
      addressMailing: address
    }
    consent:{
      agreedAt: '2024-06-26T21:17:22'
      agreedBy: 'Sau'
      agreementKeys: ['DNRA','DNPA']
    }
    privacy: true
    autoRenew: false
    dnsType: 'AzureDns'
    dnsZoneId: dnszone.id
  }
}
