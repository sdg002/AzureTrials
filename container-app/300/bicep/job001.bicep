param name string
param location string = resourceGroup().location
param acaenvironmentname string

resource acaenvironment 'Microsoft.App/managedEnvironments@2024-03-01' existing = {
  name: acaenvironmentname
}

/*
Work in progress
https://learn.microsoft.com/en-us/azure/templates/microsoft.app/jobs?pivots=deployment-language-bicep
*/

resource samplejob 'Microsoft.App/jobs@2024-03-01' = {
  name: name
  location:location
  tags: resourceGroup().tags
  properties:{
    configuration:{replicaTimeout:}
  }
}
