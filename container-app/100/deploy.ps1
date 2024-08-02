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

<#
Create Azure Container Environment
#>
Write-Host "Deploying container apps environment $Global:ContainerAppsEnvironment"
& az deployment group create --resource-group $Global:ResourceGroup `
    --template-file "$PSScriptRoot\bicep\acaenvironment.bicep" `
    --parameters name=$Global:ContainerAppsEnvironment  `
    logworkspacename=$Global:LogAnalytics `
    identityname=$Global:ContainerAppsEnvironmentManagedIdentity `
    --verbose
RaiseCliError -message "Failed to create container apps environment $Global:ContainerAppsEnvironment"

# do it via Bicep
# <#
# Create Azure Container Registry
# #>
# Write-Host "Creating container registry $ContainerRegistry"
# & az acr create --resource-group $Global:ResourceGroup --name $ContainerRegistry --sku Basic --admin-enabled true
# RaiseCliError -message "Failed to create container apps environment $Global:ContainerAppsEnvironment"

<#
Create Container App 
#>
Write-Host "Creating container app $Global:ContainerApp001"
& az deployment group create --resource-group $Global:ResourceGroup `
    --template-file "$PSScriptRoot\bicep\app001.bicep" `
    --parameters `
    acaenvironmentname=$Global:ContainerAppsEnvironment  `
    name=$Global:ContainerApp001 `
    --verbose
RaiseCliError -message "Failed to create container app  $Global:ContainerApp001"
