. $PSScriptRoot/variables.ps1

<#
Script for deploying all Azure resources neccessary for a Python Flask Web apps
#>

<#
Deploy resource group
#>
Write-Host "Going to create the resource group: '$Global:ResourceGroup' with the location: '$Global:Location' "
& az group create --location $Global:Location --name $Global:ResourceGroup `
    --tags department=$Global:TagDepartment owner=$Global:TagOwner costcenter=$Global:TagCostCenter
RaiseCliError -message "Failed to create the resource group $Global:ResourceGroup"

<#
Deploy App Service Plan
#>
$armTemplateFile=Join-Path -Path $PSScriptRoot -ChildPath "appserviceplan.arm.template.json"
$armParameterFile=Join-Path -Path $PSScriptRoot -ChildPath "appserviceplan.arm.parameters.json"


Write-Host "Going to create App Service Plan $Global:AppServicePlan using ARM template $armTemplateFile"
& az deployment group create --resource-group $Global:ResourceGroup --template-file $armTemplateFile `
    --parameters  @$armParameterFile `
    name=$Global:AppServicePlan `
    --verbose

RaiseCliError -message "Failed to deploy App service plan $Global:AppServicePlan"

