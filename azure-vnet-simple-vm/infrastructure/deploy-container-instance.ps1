. $PSScriptRoot\common.ps1


$AcrPassword=GetAcrPassword
$AcrLoginServer=GetAcrLogin
$StorageAccountKey=GetStorageAccountKey

$image="$AcrLoginServer/{0}:latest" -f $Global:LocalImageName
Write-Host "Begin-Creating Azure Container instance , image name=$image"

az container create --resource-group $Global:ResourceGroup --name $Global:ContainerInstanceName --image $image `
    --registry-password $AcrPassword --registry-username $Global:ContainerRegistry `
    --environment-variables STORAGE_ACCOUNT_KEY=$StorageAccountKey  STORAGE_ACCOUNT_NAME=$Global:StoAccount `
    --secure-environment-variables mysecretvariable1=mysecretvariablevalue
Write-Host "End-Creating Azure Container instance "


Write-Host "Begin-Restarting the container $Global:ContainerInstanceName"
az container restart --resource-group $Global:ResourceGroup --name $Global:ContainerInstanceName  --verbose
Write-Host "End-Restarting the container $Global:ContainerInstanceName"
