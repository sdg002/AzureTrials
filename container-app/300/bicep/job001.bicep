param name string
param location string = resourceGroup().location
param registry string
param acaenvironmentname string
param imagename string

resource acaenvironment 'Microsoft.App/managedEnvironments@2024-03-01' existing = {
  name: acaenvironmentname
}

resource registryresource 'Microsoft.ContainerRegistry/registries@2023-11-01-preview' existing = {
  name: registry
}

/*
Work in progress
https://learn.microsoft.com/en-us/azure/templates/microsoft.app/jobs?pivots=deployment-language-bicep
*/


@description('Generated from /subscriptions/635a2074-cc31-43ac-bebe-2bcd67e1abfe/resourceGroups/rg-demo-container-apps-dev-uks/providers/Microsoft.App/jobs/hellojob')
resource hellojob 'Microsoft.App/jobs@2024-03-01' = {
  name: name
  location: location
  tags: {
    tag1: 'value1'
  }
  properties: {
    environmentId: acaenvironment.id
    workloadProfileName: null
    configuration: {
      secrets: [
        {
          name: 'reg-pswd-a19d2fe4-8996'
        }
      ]
      triggerType: 'Manual'
      replicaTimeout: 1800
      replicaRetryLimit: 0
      manualTriggerConfig: {
        replicaCompletionCount: 1
        parallelism: 1
      }
      scheduleTriggerConfig: null
      eventTriggerConfig: null
      registries: [
        {
          server: 'saupycontainerregistry001dev.azurecr.io'
          username: 'saupycontainerregistry001dev'
          passwordSecretRef: 'reg-pswd-a19d2fe4-8996'
          identity: ''
        }
      ]
    }
    template: {
      containers: [
        {
          image: '${registryresource.properties.loginServer}/${imagename}'
          //image001: 'saupycontainerregistry001dev.azurecr.io/junkpython:v1'
          name: 'hellojob'
          env: [
            {
              name: 'env001'
              value: 'value001'
            }
          ]
          resources: {
            cpu: json('0.25')
            memory: '0.5Gi'
          }
        }
      ]
      initContainers: null
      volumes: null
    }
  }
  identity: {
    type: 'None'
  }
  }
