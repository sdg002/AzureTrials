. $PSScriptRoot/commonvariables.ps1



<#
Create VNET
#>
Write-Host "Deploying VNET"
& az deployment group create --resource-group $Global:ResourceGroup `
    --template-file "$PSScriptRoot\bicep\vnet.bicep" `
    --parameters vnetname=$Global:Vnet `
    --verbose
RaiseCliError -message "Failed to create VNET"


<#
Create Azure Container Environment
#>
Write-Host "Deploying container apps environment $Global:ContainerAppsEnvironment"
& az deployment group create --resource-group $Global:ResourceGroup `
    --template-file "$PSScriptRoot\bicep\acaenvironment.bicep" `
    --parameters name=$Global:ContainerAppsEnvironment  `
    logworkspacename=$Global:LogAnalytics `
    identityname=$Global:ContainerAppsEnvironmentManagedIdentity `
    vnetname=$Global:Vnet `
    --verbose
RaiseCliError -message "Failed to create container apps environment $Global:ContainerAppsEnvironment"


