. $PSScriptRoot/commonvariables.ps1

<#
Deploy resource group
#>
Write-Host "Going to create the resource group: '$Global:ResourceGroup' with the location: '$Global:Location' "
& az group create --location $Global:Location --name $Global:ResourceGroup `
    --tags  location=$Global:Location "department='my department'"
RaiseCliError -message "Failed to create the resource group $Global:ResourceGroup"

<#
Create log analytics workspace
#>
Write-Host "Deploying log analytics $Global:LogAnalytics"
& az deployment group create --resource-group $Global:ResourceGroup `
    --template-file "$PSScriptRoot\bicep\loganalytics.bicep" `
    --parameters name=$Global:LogAnalytics  --verbose
RaiseCliError -message "Failed to create log analytics workspace $Global:LogAnalytics"

Write-Host "Deploying container apps environment $Global:ContainerAppsEnvironment"
& az deployment group create --resource-group $Global:ResourceGroup `
    --template-file "$PSScriptRoot\bicep\acaenvironment.bicep" `
    --parameters name=$Global:ContainerAppsEnvironment  `
    logworkspacename=$Global:LogAnalytics `
    --verbose
RaiseCliError -message "Failed to create container apps environment $Global:ContainerAppsEnvironment"

