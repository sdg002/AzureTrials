. $PSScriptRoot\common.ps1


function CreateStorageAccount{
    Write-Host "Begin - creating storage account $Global:StoAccount"
    & az storage account create --name $Global:StoAccount --resource-group $Global:ResourceGroup `
        --access-tier "Cool" --allow-blob-public-access "false" `
        --allow-blob-public-access "false" --https-only "true" `
        --location $Global:Location --sku "Standard_LRS" `
        --tags $Global:Tags
    ThrowErrorIfExitCode -message "Error while creating storage account $Global:StoAccount"    
    Write-Host "End - creating storage account $Global:StoAccount"

    <#
        --public-network-access Disabled `
        --vnet-name $Global:Vnet --subnet "default" --default-action "Allow"

Validation of network acls failure: SubnetsHaveNoServiceEndpointsConfigured:Subnets default of virtual network /subscriptions/635a2074-cc31-43ac-bebe-2bcd67e1abfe/resourceGroups/rg-demo-vm-vnet-experiment/providers/Microsoft.Network/virtualNetworks/myVnet do not have ServiceEndpoints for Microsoft.Storage resources configured. Add Microsoft.Storage to subnet's ServiceEndpoints collection before trying to ACL Microsoft.Storage resources to 
these subnets.."    
    #>
}
CreateStorageAccount
