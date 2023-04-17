. $PSScriptRoot\common.ps1


function CreateStorageAccount{
    Write-Host "Begin - creating storage account $Global:StoAccount"
    & az storage account create --name $Global:StoAccount --resource-group $Global:ResourceGroup `
        --access-tier "Cool" --allow-blob-public-access "false" `
        --https-only "true" --location $Global:Location --sku "Standard_LRS" `
        --tags $Global:Tags
    ThrowErrorIfExitCode -message "Error while creating storage account $Global:StoAccount"    
    Write-Host "End - creating storage account $Global:StoAccount"

    <#
        --public-network-access "Disabled" 
        --public-network-access Disabled `
        --vnet-name $Global:Vnet --subnet "default" --default-action "Allow"

Validation of network acls failure: SubnetsHaveNoServiceEndpointsConfigured:Subnets default of virtual network /subscriptions/635a2074-cc31-43ac-bebe-2bcd67e1abfe/resourceGroups/rg-demo-vm-vnet-experiment/providers/Microsoft.Network/virtualNetworks/myVnet do not have ServiceEndpoints for Microsoft.Storage resources configured. Add Microsoft.Storage to subnet's ServiceEndpoints collection before trying to ACL Microsoft.Storage resources to 
these subnets.."    
    #>
}

function AddNetworkRule{
    Write-Host "Begin - Adding network rule to $Global:StoAccount, Subnet=default"
    & az storage account network-rule add `
    --resource-group $Global:ResourceGroup --account-name $Global:StoAccount `
    --vnet-name $Global:Vnet --subnet "default"    
    ThrowErrorIfExitCode -message "Error while adding network rule to $Global:StoAccount"
    Write-Host "End - Adding network rule to $Global:StoAccount, Subnet=default"

    Write-Host "Begin - Adding network rule to $Global:StoAccount, Subnet=$Global:SubnetContainers"
    & az storage account network-rule add `
    --resource-group $Global:ResourceGroup --account-name $Global:StoAccount `
    --vnet-name $Global:Vnet --subnet $Global:SubnetContainers   
    ThrowErrorIfExitCode -message "Error while adding network rule to $Global:StoAccount"
    Write-Host "End - Adding network rule to $Global:StoAccount, Subnet=$Global:SubnetContainers"
}


function PreventPublicAccess{
    Write-Host "Begin - disabling public access for the storage account $Global:StoAccount"    
    & az storage account update --name $Global:StoAccount --resource-group $Global:ResourceGroup `
        --allow-blob-public-access "false" `
        --bypass AzureServices `
        --default-action "Deny" `
        --verbose

    ThrowErrorIfExitCode -message "Error while enabling public access $Global:StoAccount"
    Write-Host "End - disabling public access for the storage account $Global:StoAccount"    
}


CreateStorageAccount
AddNetworkRule
PreventPublicAccess