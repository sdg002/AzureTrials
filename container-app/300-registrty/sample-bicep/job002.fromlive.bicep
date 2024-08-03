
@description('Generated from /subscriptions/635a2074-cc31-43ac-bebe-2bcd67e1abfe/resourceGroups/rg-demo-container-apps-dev-uks/providers/Microsoft.App/jobs/hellojob')
resource hellojob 'Microsoft.App/jobs@2024-03-01' = {
  name: 'hellojob'
  location: 'UK South'
  tags: {
    tag1: 'value1'
  }
  systemData: {
    createdBy: 'saurabh_dasgupta@hotmail.com'
    createdByType: 'User'
    createdAt: '2024-07-31T06:31:30.5445404'
    lastModifiedBy: 'saurabh_dasgupta@hotmail.com'
    lastModifiedByType: 'User'
    lastModifiedAt: '2024-07-31T06:31:30.5445404'
  }
  properties: {
    provisioningState: 'Succeeded'
    environmentId: '/subscriptions/635a2074-cc31-43ac-bebe-2bcd67e1abfe/resourceGroups/rg-demo-container-apps-dev-uks/providers/Microsoft.App/managedEnvironments/caedemosauuksouth001'
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
      dapr: null
    }
    template: {
      containers: [
        {
          image: 'saupycontainerregistry001dev.azurecr.io/junkpython:v1'
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
            ephemeralStorage: '1Gi'
          }
        }
      ]
      initContainers: null
      volumes: null
    }
    eventStreamEndpoint: 'https://uksouth.azurecontainerapps.dev/subscriptions/635a2074-cc31-43ac-bebe-2bcd67e1abfe/resourceGroups/rg-demo-container-apps-dev-uks/containerApps/hellojob/eventstream'
  }
  identity: {
    type: 'None'
  }
}
