. $PSScriptRoot\variables.ps1

<#
We are querying the key of the storage account using Azure CLI and adding this key as a secret to the Azure KeyVault using the CLI
#>


$armTemplateFile=Join-Path -Path $PSScriptRoot -ChildPath "templates/keyvault.arm.json"
$armParameterFile=Join-Path -Path $PSScriptRoot -ChildPath "templates/keyvault.parameters.json"

Write-Host "Going to create the Key Vault $VaultName using ARM template $armTemplateFile"
& az deployment group create --resource-group $Global:ResourceGroup --template-file $armTemplateFile `
    --parameters  `
    @$armParameterFile `
    name=$Global:KeyVault `
    --verbose

RaiseCliError -message "Failed to create the Key Vault"


$armTemplateFile=Join-Path -Path $PSScriptRoot -ChildPath "templates/eventhub.arm.json"

Write-Host "Going to create the Event Hub  $Global:EventHubNameSpace using ARM template $armTemplateFile"
& az deployment group create --resource-group $Global:ResourceGroup --template-file $armTemplateFile `
    --parameters  `
    name=$Global:EventHubNameSpace `
    --verbose

RaiseCliError -message "Failed to create the Key Vault"


