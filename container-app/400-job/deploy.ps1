. $PSScriptRoot/commonvariables.ps1

<#
Create Job
#>
Write-Host "Deploying Job Job001"
& az deployment group create --resource-group $Global:ResourceGroup `
    --template-file "$PSScriptRoot\bicep\job001.bicep" `
    --parameters name=$Global:ContainerJob001 `
    registry=$Global:ContainerRegistry `
    acaenvironmentname=$Global:ContainerAppsEnvironment `
    imagename=$Global:LocalImageName `
    --verbose
RaiseCliError -message "Failed to deploy job Job001"
