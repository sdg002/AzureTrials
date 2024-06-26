Set-StrictMode -Version "latest"
$ErrorActionPreference="Stop"

$environment=$env:environment
if ([string]::IsNullOrWhiteSpace($environment)){
    Write-Error -Message "The variable 'environment' was empty. Should be set to dev or uat or prod"
}

$Global:ResourceGroup="rg-demo-python-docker-$environment"
$Global:Location="uksouth"
$Global:LogAnalyticsWorkspace="pythondocker-log-workspace-$environment"
$Global:ApplicationInsights="python-docker-appinsights-$environment"
$Global:ContainerRegistry=("saupycontainerregistry001{0}" -f $env:environment)
$Global:ContainerGroup=("saucontainergroup-{0}" -f  $env:environment)


function ThrowErrorIfExitCode($message){
    if (0 -eq $LASTEXITCODE){
        return
    }
    Write-Error -Message $message
}


function GetAzureContainerRegisryLoginUrl(){
    $acrJson=& az acr show --name $ContainerRegistry --resource-group $ResourceGroup
    $acrJsonObject=$acrJson | ConvertFrom-Json
    return $acrJsonObject.loginServer
}