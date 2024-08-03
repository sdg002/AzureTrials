. $PSScriptRoot/../common.ps1


$Global:LocalImageName="junkpython"
$Global:ContainerJob001=("job{0}{1}001" -f $env:environment, $Global:Location)


function GetAzureContainerRegisryLoginUrl(){
    $acrJson=& az acr show --name $ContainerRegistry --resource-group $Global:ResourceGroup
    $acrJsonObject=$acrJson | ConvertFrom-Json
    return $acrJsonObject.loginServer
}