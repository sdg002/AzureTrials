. $PSScriptRoot/../common.ps1



$Global:LogAnalytics="democontainerapplogworkspace$($Global:environment)"
$Global:ContainerAppsEnvironment="caedemosau$($Location)001"
$Global:ContainerRegistry=("saupycontainerregistry001{0}" -f $env:environment)
$Global:ContainerApp001=("casau{0}{1}" -f $env:environment, $Global:Location)

