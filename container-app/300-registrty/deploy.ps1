. $PSScriptRoot/commonvariables.ps1

<#
Create container registry
#>
Write-Host "Deploying container registry $Global:ContainerRegistry"
& az deployment group create --resource-group $Global:ResourceGroup `
    --template-file "$PSScriptRoot\bicep\containerregistry.bicep" `
    --parameters name=$Global:ContainerRegistry  --verbose
RaiseCliError -message "Failed to create Container registry $Global:ContainerRegistry"


<#
Create dns zone
Write-Host "Deploying DNS zone $Global:DnsZone"
& az deployment group create --resource-group $Global:ResourceGroup `
    --template-file "$PSScriptRoot\bicep\dnszone.bicep" `
    --parameters name=$Global:DnsZone  --verbose
RaiseCliError -message "Failed to create DNS zone $Global:DnsZone"
#>

