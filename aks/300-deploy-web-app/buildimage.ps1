. $PSScriptRoot/../common.ps1


# Attention! When using "az acr build" specify the absolute path to the folder with Dockerfile
$dockerfilefolder=Join-Path -Path $PSScriptRoot -ChildPath "../demo-flask-app/"
$dockerfilefolder=Resolve-Path -Path $dockerfilefolder
Write-Host "Do a Docker build using ACR $dockerfilefolder"
az acr build --registry $Global:ContainerRegistry --image $Global:WebAppDockerTagName $dockerfilefolder
RaiseCliError -message "Failed to create namespaces"
