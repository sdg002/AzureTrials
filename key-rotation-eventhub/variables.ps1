Set-StrictMode -Version "latest"
$ErrorActionPreference="Stop"
$global:ResourceGroup="rg-demo-event-hub-key-rotation"
$global:EventHubNameSpace="saueventhub001"
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