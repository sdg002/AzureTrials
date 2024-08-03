. $PSScriptRoot/commonvariables.ps1

<#
Create Role Assignment
#>
Write-Host "Deploying registryroleassignment.bicep"
& az deployment group create --resource-group $Global:ResourceGroup `
    --template-file "$PSScriptRoot\bicep\registryroleassignment.bicep" `
    --parameters `
    registryname=$Global:ContainerRegistry `
    acaenvironmentname=$Global:ContainerAppsEnvironment `
    --verbose
RaiseCliError -message "Failed to do role assignment"



