Set-StrictMode -Version "latest"
$ErrorActionPreference="Stop"
$Global:ResourceGroup="rg-demo-arm-template-experiments"
$Global:Location="uksouth"


<#
This function should be called after every invocation of Azure CLI to check for success
#>
function RaiseCliError($message){
    if ($LASTEXITCODE -eq 0){
        return
    }
    Write-Error -Message $message
}