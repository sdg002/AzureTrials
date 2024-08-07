Set-StrictMode -Version "latest"
$ErrorActionPreference="Stop"
$Global:environment=$env:ENVIRONMENT
if ([string]::IsNullOrWhiteSpace($Global:environment)){
    Write-Error -Message "The environment variable 'ENVIRONMENT' was not set"
}
Write-Host "The environment is $Global:environment"
$Global:ResourceGroup="rg-demo-container-apps-$Global:environment-uks"
$Global:Location="uksouth"


$Global:LogAnalytics="democontainerapplogworkspace$($Global:environment)"
$Global:ContainerAppsEnvironment="caedemosau$($Location)001"
$Global:ContainerRegistry=("saupycontainerregistry001{0}" -f $env:environment)
$Global:ContainerAppsEnvironmentManagedIdentity=("{0}identity" -f $Global:ContainerAppsEnvironment)


<#
This function should be called after every invocation of Azure CLI to check for success
#>
function RaiseCliError($message){
    if ($LASTEXITCODE -eq 0){
        return
    }
    Write-Error -Message $message
}

<#
ThrowErrorIfExitCode is more sensible
#>
function ThrowErrorIfExitCode($message){
    if (0 -eq $LASTEXITCODE){
        return
    }
    Write-Error -Message $message
}