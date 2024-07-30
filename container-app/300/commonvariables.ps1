. $PSScriptRoot/../common.ps1



$Global:LocalImageName="junkpython"

function GetAzureContainerRegisryLoginUrl(){
    $acrJson=& az acr show --name $ContainerRegistry --resource-group $Global:ResourceGroup
    $acrJsonObject=$acrJson | ConvertFrom-Json
    return $acrJsonObject.loginServer
}