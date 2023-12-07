Set-StrictMode -Version "latest"
$ErrorActionPreference="Stop"
$global:ResourceGroup="RG-BICEP-DEMO-001"
$Global:Location="uksouth"
$Global:KeyVault="saudemovault456"
$Global:TagDepartment="finance"
$Global:TagCostCenter="eusales"
$Global:TagOwner="janedoe@cool.com"


<#
This function should be called after every invocation of Azure CLI to check for success
#>
function RaiseCliError($message){
    if ($LASTEXITCODE -eq 0){
        return
    }
    Write-Error -Message $message
}