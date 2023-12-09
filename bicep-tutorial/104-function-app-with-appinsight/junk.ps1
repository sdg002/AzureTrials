. $PSScriptRoot/../common.ps1
. $PSScriptRoot/variables.ps1

<#
Deploying the Storage account for 
#>
Write-Host "Deploying  Function App $Global:FirstFunctionApp"
& az deployment group create --resource-group $Global:ResourceGroup `
    --template-file "$PSScriptRoot\templates\functionapp.bicep" `
    --parameters name=$Global:FirstFunctionApp `
    storageaccount=$Global:FunctionStorageAccount `
    planname=$Global:AppPlan `
    --verbose
RaiseCliError -message "Failed to create function app $Global:FirstFunctionApp"
