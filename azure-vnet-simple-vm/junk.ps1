. $PSScriptRoot\common.ps1

Write-Host "Displaying network rules"
<#
& az storage account network-rule list --resource-group $Global:ResourceGroup --account-name $Global:StoAccount

#>

az storage account network-rule add `
    --resource-group $Global:ResourceGroup --account-name $Global:StoAccount `
    --vnet-name $Global:Vnet --subnet "default"
    
ThrowErrorIfExitCode -message "Error while adding network rule to $Global:StoAccount"    