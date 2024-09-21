Set-StrictMode -Version "latest"
$ErrorActionPreference="Stop"

<#
This function should be called after every invocation of Azure CLI to check for success
#>
function RaiseCliError($message){
    if ($LASTEXITCODE -eq 0){
        return
    }
    Write-Error -Message $message
}

$global:ResourceGroup="RG-AKS-DEMO-001"
$Global:Aks="aks-viacli-dev"