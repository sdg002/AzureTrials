. $PSScriptRoot\common.ps1


$AcrPassword=GetAcrPassword
$AcrLoginServer=GetAcrLogin
$StorageAccountKey=GetStorageAccountKey

$image="$AcrLoginServer/{0}:latest" -f $Global:LocalImageName
Write-Host "Begin-Creating Azure Container instance , image name=$image"

az container create --resource-group $Global:ResourceGroup --name $Global:ContainerInstanceName --image $image `
    --registry-password $AcrPassword --registry-username $Global:ContainerRegistry `
    --environment-variables STORAGE_ACCOUNT_KEY=$StorageAccountKey  STORAGE_ACCOUNT_NAME=$Global:StoAccount
Write-Host "End-Creating Azure Container instance "


#YOU WERE HEE, 
#GET THE STORAGE ACCOUNT CN STRING (common.ps1)

