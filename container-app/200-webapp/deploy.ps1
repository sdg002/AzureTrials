. $PSScriptRoot/commonvariables.ps1

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
