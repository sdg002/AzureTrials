param location string = resourceGroup().location
param name string
param sku string

resource appServicePlan 'Microsoft.Web/serverfarms@2020-12-01' = {
  name: name
  location: location
  tags:resourceGroup().tags
  kind: 'linux'
  properties:{
    targetWorkerCount:1
    targetWorkerSizeId:0
    reserved:true    
  }
  sku: {
    tier: 'Basic'
    name: sku
    capacity: 1
  }
}
