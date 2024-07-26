. $PSScriptRoot/commonvariables.ps1



<#
Create dns zone
#>
Write-Host "Deploying DNS zone $Global:DnsZone"
& az deployment group create --resource-group $Global:ResourceGroup `
    --template-file "$PSScriptRoot\bicep\dnszone.bicep" `
    --parameters name=$Global:DnsZone  --verbose
RaiseCliError -message "Failed to create DNS zone $Global:DnsZone"

<#
Create App Service Domain
#>
Write-Host "Deploying app service domain $Global:AppServiceDomain"
& az deployment group create --resource-group $Global:ResourceGroup `
    --template-file "$PSScriptRoot\bicep\appservicedomain.bicep" `
    --parameters name=$Global:DnsZone  `
    dnszonename=$Global:AppServiceDomain `
    --verbose
RaiseCliError -message "Failed to app service domain $Global:AppServiceDomain"

