. $PSScriptRoot/../common.ps1
. $PSScriptRoot/variables.ps1


<#
Assign RBAC access for the function app
#>
Write-Host "Deploying function app  $Global:FirstFunctionApp access policy for the Key Vault $Global:KeyVault"
& az deployment group create --resource-group $Global:ResourceGroup `
    --template-file "$PSScriptRoot\templates\functionappvaultaccess.bicep" `
    --parameters keyvaultname=$Global:KeyVault  `
    functionapp=$Global:FirstFunctionApp `
    --verbose
RaiseCliError -message "Failed to add RBAC access to the managed identity"
