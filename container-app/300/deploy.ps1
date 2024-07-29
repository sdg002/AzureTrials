. $PSScriptRoot/commonvariables.ps1



<#
Create dns zone
Write-Host "Deploying DNS zone $Global:DnsZone"
& az deployment group create --resource-group $Global:ResourceGroup `
    --template-file "$PSScriptRoot\bicep\dnszone.bicep" `
    --parameters name=$Global:DnsZone  --verbose
RaiseCliError -message "Failed to create DNS zone $Global:DnsZone"
#>

