. $PSScriptRoot\common.ps1



function CreateVnet{
    Write-Host "Begin.Going to create VNET $Global:Vnet"
    & az network vnet create --name $Global:Vnet `
    --resource-group $Global:ResourceGroup `
    --location $Global:Location `
    --subnet-name "default" --verbose
    
    ThrowErrorIfExitCode -message "Error while creating VNET $Global:Vnet"
    Write-Host "End.Going to create VNET $Global:Vnet"
}

function CreateSubnetForContainer{
    Write-Host "Begin.Going to create subnet $Global:SubnetContainers"
    $addrPrefix="10.0.2.0/24"
    # "10.0.2.0/24" worked because , this worked because this avoids any overlap of IP range with the default subnet
    # "10.0.0.32/27" did not work
    #"10.0.0.0/27" did not work
    & az network vnet subnet create --resource-group $Global:ResourceGroup --vnet-name $Global:Vnet `
    --name $Global:SubnetContainers --address-prefixes $addrPrefix --verbose
    ThrowErrorIfExitCode -message "Error while creating VNET $Global:SubnetContainers"
    Write-Host "End.Going to create subnet $Global:SubnetContainers"
}
CreateVnet
CreateSubnetForContainer
Write-Host "Complete"
