. $PSScriptRoot\common.ps1


$AcrPassword=GetAcrPassword
$AcrLoginServer=GetAcrLogin

$image="$AcrLoginServer/{0}:latest" -f $Global:LocalImageName
Write-Host "Begin-Creating Azure Container instance , image name=$image"

az container create --resource-group $Global:ResourceGroup --name $Global:ContainerInstanceName --image $image `
    --registry-password $AcrPassword --registry-username $Global:ContainerRegistry
Write-Host "End-Creating Azure Container instance "

