. $PSScriptRoot\common.ps1


$AcrPassword=GetAcrPassword
$AcrLoginServer=GetAcrLogin

Write-Host "Begin-Creating Azure Container instance "
$image="$AcrLoginServer/pythonworkerapp:latest"
az container create --resource-group $Global:ResourceGroup --name $Global:ContainerInstanceName --image $image `
    --registry-password $AcrPassword --registry-username $Global:ContainerRegistry
Write-Host "End-Creating Azure Container instance "

