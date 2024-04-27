. $PSScriptRoot/commonvariables.ps1


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

