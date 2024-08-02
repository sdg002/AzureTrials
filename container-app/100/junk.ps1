. $PSScriptRoot/commonvariables.ps1


<#
Create Azure Container Environment
#>
Write-Host "Deploying container apps environment $Global:ContainerAppsEnvironment"
& az deployment group create --resource-group $Global:ResourceGroup `
    --template-file "$PSScriptRoot\bicep\acaenvironment.bicep" `
    --parameters name=$Global:ContainerAppsEnvironment  `
    logworkspacename=$Global:LogAnalytics `
    --verbose
RaiseCliError -message "Failed to create container apps environment $Global:ContainerAppsEnvironment"
