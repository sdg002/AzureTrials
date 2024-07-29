. $PSScriptRoot/../common.ps1



$Global:ContainerRegistry=("saupycontainerregistry001{0}" -f $env:environment)
$Global:LocalImageName="junkpython"

function GetAzureContainerRegisryLoginUrl(){
    $acrJson=& az acr show --name $ContainerRegistry --resource-group $Global:ResourceGroup
    $acrJsonObject=$acrJson | ConvertFrom-Json
    return $acrJsonObject.loginServer
}