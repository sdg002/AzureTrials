. $PSScriptRoot/commonvariables.ps1


# YOU WERE HERE
# BRING IN ALL ARM TEMPLATES , 
# PUT THE TEMPLATE+PARAMETER FILES IN THEIR RESPSECTIVE SUB-FOLDERS

<#
Deploy resource group
#>
Write-Host "Going to create the resource group: '$Global:ResourceGroup' with the location: '$Global:Location' "
& az group create --location $Global:Location --name $Global:ResourceGroup `
    --tags  location=$Global:Location
RaiseCliError -message "Failed to create the resource group $Global:ResourceGroup"


<#
Deploy App Service Plan
#>
$armTemplateFile=Join-Path -Path $PSScriptRoot -ChildPath "templates/appserviceplan.arm.template.json"
$armParameterFile=Join-Path -Path $PSScriptRoot -ChildPath "templates/appserviceplan.arm.parameters.json"
Write-Host "Going to create App Service Plan $Global:AppServicePlan using ARM template $armTemplateFile"
& az deployment group create --resource-group $Global:ResourceGroup `
    --template-file $armTemplateFile `
    --parameters  @$armParameterFile `
    name=$Global:AppServicePlan `
    --verbose

RaiseCliError -message "Failed to create app service plan $Global:AppServicePlan"


<#
Deploy Web app
#>
$armTemplateFile=Join-Path -Path $PSScriptRoot -ChildPath "templates/webapp.arm.template.json"
$armParameterFile=Join-Path -Path $PSScriptRoot -ChildPath "templates/webapp.arm.parameters.json"
Write-Host "Going to create a web app using ARM template $armTemplateFile"
& az deployment group create --resource-group $Global:ResourceGroup --template-file $armTemplateFile `
    --parameters @$armParameterFile  `
    name=$Global:WebAppName hostingPlanName=$Global:AppServicePlan `
    environment=$Global:environment `
    --verbose

RaiseCliError -message "Failed to deploy web app $Global:WebAppName"

<#
Deploy Log Analytics
#>
$armTemplateFile=Join-Path -Path $PSScriptRoot -ChildPath "templates/loganalytics.arm.template.json"
$armParameterFile=Join-Path -Path $PSScriptRoot -ChildPath "templates/loganalytics.arm.parameters.json"
Write-Host "Going to Log Analytics using ARM template $armTemplateFile"
& az deployment group create --resource-group $Global:ResourceGroup --template-file $armTemplateFile `
    --parameters @$armParameterFile  `
    name=$Global:LogAnalytics `
    --verbose

RaiseCliError -message "Failed to deploy web app $Global:WebAppName"



