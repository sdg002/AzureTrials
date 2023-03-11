. $PSScriptRoot\common.ps1

<#
You will need to set the following environment variables:
AZURE_STORAGE_KEY
#>
$env:AZURE_STORAGE_ACCOUNT=$Global:StoAccount
if ($null -eq $env:AZURE_STORAGE_KEY)
{
    Write-Host  "Have you copied the Storage Account Key to clipboard ? Press a key when ready"
    [Console]::ReadKey($true)
    $env:AZURE_STORAGE_KEY=(Get-Clipboard)
}
else {
    Write-Host "The environment variable AZURE_STORAGE_KEY already has a value. This will be used for connecting"
}

Write-Host "Querying storage account"
& az storage container list