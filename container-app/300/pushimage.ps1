. $PSScriptRoot/commonvariables.ps1

$UrlRegistry=GetAzureContainerRegisryLoginUrl
Write-Host "Url of registry is $UrlRegistry"


Write-Host "Going to login into $Global:ContainerRegistry"
& az acr login --name $Global:ContainerRegistry
ThrowErrorIfExitCode -Message "Login failed :  $ContainerRegistry"
Write-Host "login succeeded"

