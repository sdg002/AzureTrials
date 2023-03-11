. $PSScriptRoot\common.ps1

<#
You will need to set the following environment variables:
AZURE_STORAGE_KEY
#>
$env:AZURE_STORAGE_ACCOUNT=$Global:StoAccount
Write-Host  "Have you copied the Storage Account Key to clipboard ? Press a key when ready"
[Console]::ReadKey($true)
$env:AZURE_STORAGE_KEY=(Get-Clipboard)
Write-Host "Querying storage account"
& az storage container list