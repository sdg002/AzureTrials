. $PSScriptRoot/commonvariables.ps1



<#
Create VNET
#>
Write-Host "Deploying VNET"
& az deployment group create --resource-group $Global:ResourceGroup `
    --template-file "$PSScriptRoot\bicep\vnet.bicep" `
    --verbose
RaiseCliError -message "Failed to create VNET"


