. $PSScriptRoot\common.ps1


<#
This script will:
    Build the image
    Depoy the image to Azure Container registry
    Create a container group

To be done
    Get url of container registry
#>
Write-Host "Going to upload image to the registry $ContainerRegistry"

#& docker push saupycontainerregistry001dev.azurecr.io/saupythonhello:latest

$LocalImageName="saupythonhello"
$AzureContainerUrl="saupycontainerregistry001dev.azurecr.io"
$LocalImageWithRemoteTag=("$AzureContainerUrl/{0}:v1" -f $LocalImageName)

& az acr login --name $ContainerRegistry
ThrowErrorIfExitCode -Message "Login failed :  $ContainerRegistry"
Write-Host "login succeeded"

Write-Host "Tagging local image"
& docker tag $LocalImageName $LocalImageWithRemoteTag
ThrowErrorIfExitCode -Message "Docker tag failed"
Write-Host "Tagging local image succeeded"

Write-Host "Pushing the local docker image $LocalImageWithRemoteTag"
docker push  "$LocalImageWithRemoteTag"
ThrowErrorIfExitCode -Message "Docker push failed"
#& az acr
Write-Host "Push complete"

Write-Host "Deleting image with remote tag $LocalImageWithRemoteTag"
& docker rmi $LocalImageWithRemoteTag
ThrowErrorIfExitCode -Message "Delete of local image failed"
Write-Host "Delete complete"

Write-Host "Listing all the images in the container registry $ContainerRegistry"
& az acr repository list --name  $ContainerRegistry --resource-group $Global:ResourceGroup
ThrowErrorIfExitCode -Message "Listing failed"

