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
Deploying first function app
#>

# Write-Host "Deploying Application Insights $Global:ApplicationInsights"
# & az deployment group create --resource-group $Global:ResourceGroup `
#     --template-file "$PSScriptRoot\templates\appinsight.bicep" `
#     --parameters `
#     name=$Global:ApplicationInsights `
#     logworkspace=$Global:LogAnalyticsWorkspace  --verbose
# RaiseCliError -message "Failed to create Application Insights $Global:ApplicationInsights"






