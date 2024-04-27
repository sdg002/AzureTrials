. $PSScriptRoot/commonvariables.ps1

# <#
# Deploy Application Insights
# #>
# $armTemplateFile=Join-Path -Path $PSScriptRoot -ChildPath "templates/appinsights.arm.template.json"
# $armParameterFile=Join-Path -Path $PSScriptRoot -ChildPath "templates/appinsights.arm.parameters.json"
# Write-Host "Going to Log Analytics using ARM template $armTemplateFile"
# & az deployment group create --resource-group $Global:ResourceGroup --template-file $armTemplateFile `
#     --parameters @$armParameterFile  `
#     name=$Global:AppInsight `
#     logWorkspaceName=$Global:LogAnalytics `
#     --verbose

# RaiseCliError -message "Failed to Application Insights $Global:LogAnalytics"

Write-Host "Begin-Deleting action groups"
$resources=az resource list --resource-group $Global:ResourceGroup --resource-type "microsoft.insights/actionGroups"  --query "[].[name]" --output tsv 
$resources
foreach ($resource in $resources) { az resource delete --resource-group $Global:ResourceGroup  --resource-type "microsoft.insights/actionGroups"  --name $resource --verbose }
Write-Host "End-Deleting action groups"


<#
Deploy Email Action Group
#>
az resource delete --resource-group $Global:ResourceGroup --name $Global:ActionGroupEmail --resource-type "microsoft.insights/actionGroups" --verbose
$armTemplateFile=Join-Path -Path $PSScriptRoot -ChildPath "templates/action-group-email.arm.template.json"
Write-Host "Going to create an Action Group $Global:ActionGroupEmail using ARM template $armTemplateFile"
& az deployment group create --resource-group $Global:ResourceGroup --template-file $armTemplateFile `
    --parameters `
    name=$Global:ActionGroupEmail `
    --verbose

RaiseCliError -message "Failed to deploy Action Group $Global:ActionGroupEmail"

<#
Deploy Webhook Action Group
#>
az resource delete --resource-group $Global:ResourceGroup --name $Global:ActionGroupWebHook --resource-type "microsoft.insights/actionGroups" --verbose
$armTemplateFile=Join-Path -Path $PSScriptRoot -ChildPath "templates/action-group-webhook.arm.template.json"
Write-Host "Going to create an Action Group $Global:ActionGroupWebHook using ARM template $armTemplateFile"
& az deployment group create --resource-group $Global:ResourceGroup --template-file $armTemplateFile `
    --parameters `
    name=$Global:ActionGroupWebHook `
    webhookendpoint=$Global:WebhookEndPoint `
    --verbose

RaiseCliError -message "Failed to deploy Action Group $Global:ActionGroupWebHook"

<#
Deploy Azure Alert
#>
$armTemplateFile=Join-Path -Path $PSScriptRoot -ChildPath "templates/alert.arm.template.json"
Write-Host "Going to create a Alert using ARM template $armTemplateFile"
& az deployment group create --resource-group $Global:ResourceGroup --template-file $armTemplateFile `
    --parameters `
    name=$Global:AlertName  `
    actionGroupEmail=$Global:ActionGroupEmail `
    actionGroupWebHook=$Global:ActionGroupWebHook `
    appinsight=$Global:AppInsight `
    --verbose

RaiseCliError -message "Failed to deploy Alert $Global:AlertName"

Write-Host "Complete"
Get-Date