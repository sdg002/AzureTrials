. $PSScriptRoot\common.ps1


$AzureContainerUrl=GetAcrLogin
$LocalImageWithRemoteTag=("$AzureContainerUrl/{0}" -f $Global:LocalImageName)
Write-Host "The remote tag is $LocalImageWithRemoteTag"


Write-Host "Going to do a login into ACR"
& az acr login --name $Global:ContainerRegistry
ThrowErrorIfExitCode -Message "Login failed :  $Global:ContainerRegistry"
Write-Host "Login succeeded"

Write-Host "Tagging local image with remote tag"
& docker tag $LocalImageName $LocalImageWithRemoteTag
ThrowErrorIfExitCode -Message "Docker tag failed"
Write-Host "Tagging local image succeeded"

Write-Host "Pushing the local docker image $LocalImageWithRemoteTag"
docker push  "$LocalImageWithRemoteTag"
ThrowErrorIfExitCode -Message "Docker push failed"

Write-Host "Push complete"


