Set-StrictMode -Version "latest"
$ErrorActionPreference="Stop"



$Global:environment=$env:ENVIRONMENT
if ([string]::IsNullOrWhiteSpace($Global:environment)){
    Write-Error -Message "The environment variable 'ENVIRONMENT' was not set"
}
Write-Host "The environment is $Global:environment"
$Global:ResourceGroup="rg-demo-azure-alert-msteams-$Global:environment-uks"
$Global:Location="uksouth"
$Global:AppServicePlan="asp-azurealertsmsteams-$Global:environment"
$Global:WebAppName="app-azurealertsmsteams-$Global:environment"
$Global:LogAnalytics="log-azurealertsmsteams-$Global:environment-uksouth"
$Global:AppInsight="appi-azurealertsmsteams-$Global:environment-uksouth"
<#
This function should be called after every invocation of Azure CLI to check for success
#>
function RaiseCliError($message){
    if ($LASTEXITCODE -eq 0){
        return
    }
    Write-Error -Message $message
}