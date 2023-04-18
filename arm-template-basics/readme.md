[[_TOC_]]


---

# You were here,
Try out more with object outputs

# Simple object output

## arm template
```json
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {},
    "variables": {},
    "resources": [],
    "outputs":{
        "storageEndpoint": {
            "type": "object",
            "value": {
                "firstName":"john",
                "lastName":"doe",
                "id": 123
            }
          }
    }
}
```

## What to expect ?
```json
{
  "id": "/subscriptions/635a2074-cc31-43ac-bebe-2bcd67e1abfe/resourceGroups/rg-demo-vm-vnet-experiment/providers/Microsoft.Resources/deployments/just-output",
  "location": null,
  "name": "just-output",
  "properties": {
    "correlationId": "93570568-46f2-4366-aed4-c9d0e1870b08",
    "debugSetting": null,
    "dependencies": [],
    "duration": "PT0.6606555S",
    "error": null,
    "mode": "Incremental",
    "onErrorDeployment": null,
    "outputResources": [],
    "outputs": {
      "storageEndpoint": {
        "type": "Object",
        "value": {
          "firstName": "john",
          "id": 123,
          "lastName": "doe"
        }
      }
    },
    "parameters": {},
    "parametersLink": null,
    "providers": [],
    "provisioningState": "Succeeded",
    "templateHash": "3586565285340125960",
    "templateLink": null,
    "timestamp": "2023-04-17T21:10:12.703601+00:00",
    "validatedResources": null
  },
  "resourceGroup": "rg-demo-vm-vnet-experiment",
  "tags": null,
  "type": "Microsoft.Resources/deployments"
}
```

---

# References
## Step by step link on ARM templates from Microsoft
https://learn.microsoft.com/en-us/azure/azure-resource-manager/templates/template-tutorial-export-template?tabs=azure-powershell#deploy-template

## ARM template output
https://learn.microsoft.com/en-us/azure/azure-resource-manager/templates/outputs?tabs=azure-powershell

## ARM template data types
https://learn.microsoft.com/en-us/azure/azure-resource-manager/templates/data-types
