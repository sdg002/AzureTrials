. $PSScriptRoot\common.ps1


Write-Host "Getting the ACR password"
$acrCredentials=(az acr credential show --name $Global:ContainerRegistry --resource-group $Global:ResourceGroup | ConvertFrom-Json -AsHashtable)
$AcrPassword=$acrCredentials["passwords"][0]["value"]
Write-Host "Got the ACR password: $AcrPassword"


Write-Host "Begin. Getting all ACR details"
$acrInfo=az acr show --name $Global:ContainerRegistry --resource-group $Global:ResourceGroup | ConvertFrom-Json -AsHashtable
$AcrLoginServer=$acrInfo["loginServer"]
Write-Host "Got the ACR login server: $AcrLoginServer"

Write-Host "Begin-Creating Azure Container instance "
$image="$AcrLoginServer/pythonworkerapp:latest"
az container create --resource-group $Global:ResourceGroup --name $Global:ContainerInstanceName --image $image `
    --registry-password $AcrPassword --registry-username $Global:ContainerRegistry
Write-Host "End-Creating Azure Container instance "

