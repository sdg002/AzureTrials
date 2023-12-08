. $PSScriptRoot/../common.ps1
. $PSScriptRoot/variables.ps1

<#
Deploy resource group
#>
Write-Host "Going to create the resource group: '$Global:ResourceGroup' with the location: '$Global:Location' "
& az group create --location $Global:Location --name $Global:ResourceGroup `
    --tags department=$Global:TagDepartment owner=$Global:TagOwner costcenter=$Global:TagCostCenter
RaiseCliError -message "Failed to create the resource group $Global:ResourceGroup"

<#
Deploying Log analytics workspace
#>
Write-Host "Deploying Log Analytics worksapce $Global:LogAnalyticsWorkspace"
& az deployment group create --resource-group $Global:ResourceGroup `
    --template-file "$PSScriptRoot\templates\loganalyticsworkspace.bicep" `
    --parameters name=$Global:LogAnalyticsWorkspace  --verbose
RaiseCliError -message "Failed to create Log Analytics Workspace $Global:LogAnalyticsWorkspace"



