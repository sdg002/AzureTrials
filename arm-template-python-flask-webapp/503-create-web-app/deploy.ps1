. $PSScriptRoot/../commonvariables.ps1



$armTemplateFile=Join-Path -Path $PSScriptRoot -ChildPath "template.json"
$armParameterFile=Join-Path -Path $PSScriptRoot -ChildPath "parameters.json"


Write-Host "Going to create a web app using ARM template $armTemplateFile"
& az deployment group create --resource-group $Global:ResourceGroup --template-file $armTemplateFile `
    --parameters @$armParameterFile  `
    name=$Global:WebAppName hostingPlanName=$Global:AppServicePlan `
    --verbose

RaiseCliError -message "Failed to deploy storage account"
