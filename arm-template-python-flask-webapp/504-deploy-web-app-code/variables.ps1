Set-StrictMode -Version "latest"
$ErrorActionPreference="Stop"

$Global:environment="dev"
$Global:ResourceGroup="rg-demo-arm-template-python-webapp-$Global:environment-uks"
$Global:StorageAccount="stopythonwebapdemo502"
$Global:AppServicePlan="app-plan-pyflaskdemo-$Global:environment"
$Global:WebAppName="saudemowebapp123-$Global:environment"

<#
This function should be called after every invocation of Azure CLI to check for success
#>
function RaiseCliError($message){
    if ($LASTEXITCODE -eq 0){
        return
    }
    Write-Error -Message $message
}