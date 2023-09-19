. $PSScriptRoot/../common.ps1
. $PSScriptRoot/variables.ps1


<#
Deploying function app with VNET for outbound
#>
Write-Host "Deploying  Function App $Global:FirstFunctionApp"
& az deployment group create --resource-group $Global:ResourceGroup `
    --template-file "$PSScriptRoot\templates\functionapp.bicep" `
    --parameters name=$Global:FirstFunctionApp `
    storageaccount=$Global:FunctionStorageAccount `
    planname=$Global:AppPlan `
    appinsight=$Global:ApplicationInsights `
    vnet=$Global:Vnet `
    subnet=$Global:Subnet  `
    --verbose
RaiseCliError -message "Failed to create function app $Global:FirstFunctionApp"

