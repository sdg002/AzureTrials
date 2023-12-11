. $PSScriptRoot/../common.ps1
. $PSScriptRoot/variables.ps1

<#
Deploy Key Vault
#>

Write-Host "Deploying key vault $Global:KeyVault"
& az deployment group create --resource-group $Global:ResourceGroup `
    --template-file "$PSScriptRoot\templates\keyvault.bicep" `
    --parameters name=$Global:KeyVault  --verbose
RaiseCliError -message "Failed to create key vault $Global:KeyVault"




