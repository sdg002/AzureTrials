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

<#
Add secrets to the Vault
#>
Write-Host "Adding secrets to the key vault $Global:KeyVault"
& az deployment group create --resource-group $Global:ResourceGroup `
    --template-file "$PSScriptRoot\templates\keyvaultsecrets.bicep" `
    --parameters `
    keyvaultname=$Global:KeyVault `
    storageaccount=$Global:FunctionStorageAccount `
    --verbose
RaiseCliError -message "Adding secrets to the key vault $Global:KeyVault failed"

<#
Clear all role assignments
#>
$oKeyVault=& az resource show --resource-group $Global:ResourceGroup --name $Global:KeyVault --resource-type "Microsoft.KeyVault/vaults" --verbose | ConvertFrom-Json
Write-Host "Id of the key value is $($oKeyVault.id)"
RaiseCliError -message "Failed to get id of the key vault $Global:KeyVault"

az role assignment delete --scope $oKeyVault.id  --verbose


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
