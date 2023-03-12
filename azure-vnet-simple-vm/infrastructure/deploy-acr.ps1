. $PSScriptRoot\common.ps1

function CreateContainerRegistry{
    Write-Host "Creating container registry $ContainerRegistry"
    & az acr create --resource-group $Global:ResourceGroup --name $ContainerRegistry --sku Basic --admin-enabled true
    ThrowErrorIfExitCode -Message "Could not create container group $ContainerRegistry"
    Write-Host "ContainerRegistry $ContainerRegistry created"
}

CreateContainerRegistry
