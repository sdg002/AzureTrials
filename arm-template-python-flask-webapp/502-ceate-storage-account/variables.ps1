Set-StrictMode -Version "latest"
$ErrorActionPreference="Stop"

$Global:environment="dev"
$Global:ResourceGroup="rg-demo-arm-template-python-webapp-$Global:environment-uks"




<#
This function should be called after every invocation of Azure CLI to check for success
#>
function RaiseCliError($message){
    if ($LASTEXITCODE -eq 0){
        return
    }
    Write-Error -Message $message
}