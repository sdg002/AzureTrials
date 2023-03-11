. $PSScriptRoot\common.ps1



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
