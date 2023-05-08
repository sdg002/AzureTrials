. $PSScriptRoot\..\common\variables.ps1

<#
We are querying the key of the storage account using Azure CLI and adding this key as a secret to the Azure KeyVault using the CLI
#>

$VaultName="saudemovault400"
$armTemplateFile=Join-Path -Path $PSScriptRoot -ChildPath "template.json"


Write-Host "Going to add secrets to the Key Vault $VaultName using ARM template $armTemplateFile"
& az deployment group create --resource-group $Global:ResourceGroup --template-file $armTemplateFile `
    --parameters  `
    keyVaultName=$VaultName `
    --verbose

RaiseCliError -message "Failed to add secrets to the Key Vault"

