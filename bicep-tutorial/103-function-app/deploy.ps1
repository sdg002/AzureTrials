. $PSScriptRoot/../common.ps1
. $PSScriptRoot/variables.ps1

<#
Deploy App Service Plan
#>
Write-Host "Deploying App Service plan $Global:AppPlan"
& az deployment group create --resource-group $Global:ResourceGroup `
    --template-file "$PSScriptRoot\templates\appserviceplan.bicep" `
    --parameters name=$Global:AppPlan `
    sku=$Global:AppPlanSku `
    --verbose
RaiseCliError -message "Failed to create App Service Plan $Global:AppPlan"

<#
Deploying the Storage account for 
#>
Write-Host "Deploying storage account for Function App $Global:FunctionStorageAccount"
& az deployment group create --resource-group $Global:ResourceGroup `
    --template-file "$PSScriptRoot\templates\storage.bicep" `
    --parameters name=$Global:FunctionStorageAccount `
    --verbose
RaiseCliError -message "Failed to create storage account $Global:FunctionStorageAccount"

<#
Deploying first function app
#>
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

# Write-Host "Deploying Application Insights $Global:ApplicationInsights"
# & az deployment group create --resource-group $Global:ResourceGroup `
#     --template-file "$PSScriptRoot\templates\appinsight.bicep" `
#     --parameters `
#     name=$Global:ApplicationInsights `
#     logworkspace=$Global:LogAnalyticsWorkspace  --verbose
# RaiseCliError -message "Failed to create Application Insights $Global:ApplicationInsights"






