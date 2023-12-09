param location string = resourceGroup().location
param name string
param sku string

resource appServicePlan 'Microsoft.Web/serverfarms@2020-12-01' = {
  name: name
  location: location
  tags:resourceGroup().tags
  sku: {
    name: sku
    capacity: 1
  }
}
