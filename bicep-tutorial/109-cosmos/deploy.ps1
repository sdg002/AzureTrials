. $PSScriptRoot/../common.ps1
. $PSScriptRoot/variables.ps1

<#
Deploy Cosmos
#>

Write-Host "Deploying Cosmos $Global:CosmosAccount"
& az deployment group create --resource-group $Global:ResourceGroup `
    --template-file "$PSScriptRoot\templates\cosmos.bicep" `
    --parameters `
    name=$Global:CosmosAccount `
    --verbose
RaiseCliError -message "Failed to create Cosmos account $Global:CosmosAccount "

