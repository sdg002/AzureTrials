. $PSScriptRoot/commonvariables.ps1

<#
Deploy resource group
#>
Write-Host "Going to create the resource group: '$Global:ResourceGroup' with the location: '$Global:Location' "
& az group create --location $Global:Location --name $Global:ResourceGroup `
    --tags  location=$Global:Location "department='my department'"
RaiseCliError -message "Failed to create the resource group $Global:ResourceGroup"


