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
Create Role Assignment
#>
Write-Host "Deploying registryroleassignment.bicep"
& az deployment group create --resource-group $Global:ResourceGroup `
    --template-file "$PSScriptRoot\bicep\registryroleassignment.bicep" `
    --parameters `
    registryname=$Global:ContainerRegistry `
    acaenvironmentname=$Global:ContainerAppsEnvironment `
    acaidentityname=$Global:ContainerAppsEnvironmentManagedIdentity `
    --verbose
RaiseCliError -message "Failed to do role assignment"

