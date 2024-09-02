. $PSScriptRoot/../common.ps1

<#
Deploy resource group
#>
Write-Host "Going to create the resource group: '$Global:ResourceGroup' with the location: '$Global:Location' "
& az group create --location $Global:Location --name $Global:ResourceGroup `
    --tags $Global:TagsArray

<#
Create container registry
#>
Write-Host "Deploying container registry $Global:ContainerRegistry"
& az deployment group create --resource-group $Global:ResourceGroup `
    --template-file "$PSScriptRoot\bicep\containerregistry.bicep" `
    --parameters name=$Global:ContainerRegistry  --verbose
RaiseCliError -message "Failed to create Container registry $Global:ContainerRegistry"

Write-Host "Deploying AKS $Global:Aks"
az aks create `
    --resource-group $Global:ResourceGroup `
    --name $Global:Aks `
    --node-count 2 `
    --generate-ssh-keys `
    --attach-acr $Global:ContainerRegistry
RaiseCliError -message "Failed to create AKS $Global:Aks"


