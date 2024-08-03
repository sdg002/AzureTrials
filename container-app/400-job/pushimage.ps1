. $PSScriptRoot/commonvariables.ps1

$UrlRegistry=GetAzureContainerRegisryLoginUrl
Write-Host "Url of registry is $UrlRegistry"


Write-Host "Going to login into $Global:ContainerRegistry"
& az acr login --name $Global:ContainerRegistry
ThrowErrorIfExitCode -Message "Login failed :  $ContainerRegistry"
Write-Host "login succeeded"

$LocalImageWithRemoteTag=("$UrlRegistry/{0}:v1" -f $LocalImageName)

Write-Host "Tagging local image $Global:LocalImageName with remote tag $LocalImageWithRemoteTag"
& docker tag $LocalImageName $LocalImageWithRemoteTag
ThrowErrorIfExitCode -Message "Docker tag failed"
Write-Host "Tagging local image succeeded"

Write-Host "Pushing the local docker image $LocalImageWithRemoteTag"
docker push  "$LocalImageWithRemoteTag"
ThrowErrorIfExitCode -Message "Docker push failed"
#& az acr
Write-Host "Push complete"

#How do you create a job using the image uploaded (YOU WERE HERE)?
#https://learn.microsoft.com/en-us/cli/azure/containerapp/job?view=azure-cli-latest#az-containerapp-job-create
# az container app job create
