# Error while adding second subnet to network rules of Storage acount
```
(NetworkAclsValidationFailure) Validation of network acls failure: SubnetsHaveNoServiceEndpointsConfigured:Subnets mycontainer of virtual network /subscriptions/635a2074-cc31-43ac-bebe-2bcd67e1abfe/resourceGroups/rg-demo-vm-vnet-experiment/providers/Microsoft.Network/virtualNetworks/myVnet do not have ServiceEndpoints for Microsoft.Storage resources configured. Add Microsoft.Storage to subnet's ServiceEndpoints collection before trying to ACL Microsoft.Storage resources to these subnets..
Code: NetworkAclsValidationFailure
Message: Validation of network acls failure: SubnetsHaveNoServiceEndpointsConfigured:Subnets mycontainer of virtual network /subscriptions/635a2074-cc31-43ac-bebe-2bcd67e1abfe/resourceGroups/rg-demo-vm-vnet-experiment/providers/Microsoft.Network/virtualNetworks/myVnet do not have ServiceEndpoints for Microsoft.Storage resources configured. Add Microsoft.Storage to subnet's ServiceEndpoints collection before trying to ACL Microsoft.Storage resources to these subnets..

```

## Solution
I was able to add visually

## Via script

You will need to specify the 
```powershell
az network vnet subnet create --resource-group $resourceGroup --name $subnet --vnet-name $vNet --address-prefix $subnetAddressPrefix --service-endpoints Microsoft.SQL

```

you were above - create the service end point via CLI
https://learn.microsoft.com/en-us/cli/azure/network/vnet/subnet?view=azure-cli-latest#az-network-vnet-subnet-create

## Test 1
 - drop the rule on Storage account
 - run the script

## Test 2
- drop all storage rules
- drop container
- drop subnet
- re-create