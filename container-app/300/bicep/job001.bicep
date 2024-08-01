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

resource registryidentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: 'saupycontainerregistry001devidentity'
  location:resourceGroup().location
}

resource acaidentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: 'caedemosauuksouth001identity'
  location:resourceGroup().location
}


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
        // {
        //   name: 'reg-pswd-a19d2fe4-8996'
        // }
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
          server: registryresource.properties.loginServer
          //username: registryresource.properties.
          //passwordSecretRef: 'reg-pswd-a19d2fe4-8996'

          //try giving managed identity to acaenvironment ,assign acr pull
          //identity: '5829fc15-4688-48fd-a84f-2227d00f57b2' //this was the system identity of aca managed identity 5829fc15-4688-48fd-a84f-2227d00f57b2 for registry  saupycontainerregistry001dev.azurecr.io not found
          //identity: acaenvironment.identity.principalId //this defaults to system identity
          identity: acaidentity.id //this might work, need RBAC AcrPull
          
          //identity: registryidentity.id //"saupycontainerregistry001dev.azurecr.io/junkpython:v1\": managed identity /subscriptions/635a2074-cc31-43ac-bebe-2bcd67e1abfe/resourceGroups/rg-demo-container-apps-dev-uks/providers/Microsoft.ManagedIdentity/userAssignedIdentities/saupycontainerregistry001devidentity for registry saupycontainerregistry001dev.azurecr.io not found'

          //registryidentity.identity.principalId causes language expression error
          //identity: registryresource.identity.principalId Keeps defaulting to system identity
          // identity: 'system' does not work

          //identity: registryresource.identity.principalId 
          // managed identity f370c529-8cda-40eb-b1f6-bcc4cda865ef for registry  saupycontainerregistry001dev.azurecr.io not found
        }
      ]
    }
    template: {
      containers: [
        {
          //image: '${registryresource.properties.loginServer}/${imagename}'
          //Just setting image as follows causes UNAUTHORIZED: authentication required,
          image: 'saupycontainerregistry001dev.azurecr.io/junkpython:v1'
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
