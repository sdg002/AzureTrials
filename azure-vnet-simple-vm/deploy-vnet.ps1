. $PSScriptRoot\common.ps1

Write-Host "Begin.Going to create VNET $Global:Vnet"
az network vnet subnet create --name vNetIntegration --address-prefixes 10.1.1.32/27 --resource-group $Global:ResourceGroup --vnet-name $Global:Vnet


function CreateVnet{
    Write-Host "Begin.Going to create VNET $Global:Vnet"

    & az network vnet create --name $Global:Vnet `
    --resource-group $Global:ResourceGroup `
    --subnet-name default
    
    ThrowErrorIfExitCode -message "Error while creating VNET $Global:Vnet"
    Write-Host "End.Going to create VNET $Global:Vnet"
}

CreateVnet
Write-Host "Complete"
