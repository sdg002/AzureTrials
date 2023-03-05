. $PSScriptRoot\common.ps1

Write-Host "Going to create container group $ContainerGroup"

$AzureContainerUrl="saupycontainerregistry001dev.azurecr.io"
$LocalImageWithRemoteTag=("$AzureContainerUrl/{0}:v1" -f $LocalImageName)


& az container create --resource-group $Global:ResourceGroup --name $Global:ContainerGroup --image $LocalImageWithRemoteTag
ThrowErrorIfExitCode -Message "Creating container group failed"


