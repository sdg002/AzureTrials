. $PSScriptRoot\common.ps1

<#
Set the following environment variables:
AZURE_STORAGE_KEY
AZURE_STORAGE_ACCOUNT
#>
$env:AZURE_STORAGE_ACCOUNT=$Global:StoAccount
$env:AZURE_STORAGE_KEY=""
& az storage container list