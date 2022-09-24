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
$AzureContainerUrl=GetAzureContainerRegisryLoginUrl
$LocalImageWithRemoteTag=("$AzureContainerUrl/{0}:v1" -f $LocalImageName)

& az acr login --name $ContainerRegistry
ThrowErrorIfExitCode -Message "Login failed :  $ContainerRegistry"
Write-Host "login succeeded"

Write-Host "Tagging local image with remote tag"
& docker tag $LocalImageName $LocalImageWithRemoteTag
ThrowErrorIfExitCode -Message "Docker tag failed"
Write-Host "Tagging local image succeeded"

Write-Host "Pushing the local docker image $LocalImageWithRemoteTag"
docker push  "$LocalImageWithRemoteTag"
ThrowErrorIfExitCode -Message "Docker push failed"
#& az acr
Write-Host "Push complete"

Write-Host "Deleting local docker image with remote tag $LocalImageWithRemoteTag"
& docker rmi $LocalImageWithRemoteTag
ThrowErrorIfExitCode -Message "Delete of local image failed"
Write-Host "Delete complete"

Write-Host "Listing all the images in the container registry $ContainerRegistry"
& az acr repository list --name  $ContainerRegistry --resource-group $Global:ResourceGroup
ThrowErrorIfExitCode -Message "Listing failed"


$jsonCredential= & az acr credential show --name $ContainerRegistry --resource-group $ResourceGroup
ThrowErrorIfExitCode -Message "Could not get ACR credentials"

$jsonCredentialObject=$jsonCredential | ConvertFrom-Json

$acrLogin=$jsonCredentialObject.username
$acrPassword=$jsonCredentialObject.passwords[0].value
& az container create --resource-group $ResourceGroup --name $Global:ContainerGroup --image $LocalImageWithRemoteTag  --registry-username $acrLogin  --registry-password $acrPassword `
 --restart-policy Never `
 --environment-variables mykey1=myvalue1 `
 --environment-variables mykey2=myvalue2 `

ThrowErrorIfExitCode -Message "Could not created Container group"

<#

Problems when trying to start
------------------------------
Write-Host "Starting container group"
& az container start --name $ContainerGroup --resource-group $ResourceGroup

(ContainerGroupTransitioning) The container group 'saucontainergroup-dev' is still transitioning, please retry later.
Code: ContainerGroupTransitioning
Message: The container group 'saucontainergroup-dev' is still transitioning, please retry later.

Lesson
------
The container is already starting 

#>

