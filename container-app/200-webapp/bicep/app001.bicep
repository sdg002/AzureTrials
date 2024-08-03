param name string
param location string = resourceGroup().location
param acaenvironmentname string

resource acaenvironment 'Microsoft.App/managedEnvironments@2024-03-01' existing = {
  name: acaenvironmentname
}

@description('Generated from /subscriptions/635a2074-cc31-43ac-bebe-2bcd67e1abfe/resourceGroups/rg-demo-container-apps-dev-uks/providers/Microsoft.App/containerApps/hello001')
resource hello 'Microsoft.App/containerApps@2024-03-01' = {
  name: name
  location: location
  tags: {
    costcenter: 'pp 9090'
  }

  properties: {
    managedEnvironmentId: acaenvironment.id
    environmentId:acaenvironment.id
    workloadProfileName: null
    configuration: {
      secrets: []
      activeRevisionsMode: 'Single'
      ingress: {
        external: true
        targetPort: 80
        exposedPort: null
        transport: 'Auto'
        traffic: [
          {
            latestRevision: true
            weight: 100
          }
        ]
        customDomains: null
        allowInsecure: false
        ipSecurityRestrictions: null
        corsPolicy: null
        clientCertificateMode: null
        stickySessions: {
          affinity: 'none'
        }
        additionalPortMappings: []
      }
      registries: []
      dapr: null
      maxInactiveRevisions: 100
      service: null
    }
    template: {
      revisionSuffix: null
      terminationGracePeriodSeconds: null
      containers: [
        {
          image: 'docker.io/nginx:latest'
          name: 'hello001'
          command: []
          env: [
            {
              name: 'env001'
              value: 'value001'
            }
          ]
          resources: {
            cpu: json('0.25')
            memory: '.5Gi'
          }
        }
      ]
      initContainers: null
      scale: {
        minReplicas: 0
        maxReplicas: null
        rules: [
          {
            name: 'myhttprule'
            http: {
              metadata: {
                concurrentRequests: '10'
              }
            }
          }          
        ]
      }
      volumes: null
      serviceBinds: null
    }
  }
  identity: {
    type: 'None'
  }
}
