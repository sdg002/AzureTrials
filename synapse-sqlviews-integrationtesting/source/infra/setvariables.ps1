. $PSScriptRoot\common.ps1
Clear-Host

<#
Use this script to set the environment variable neccessary for Visual Studio integration tests to run properly
No need to execute to every time because we are persisting the environment variables to user scope
#>

$EndPointVariableName="demosynapseserverlessendpoint"
Write-Host "The environment is $env:Environment"
$json= (& az synapse workspace show --name $Global:SynapseWorkspaceName --resource-group $Global:SynapseResourceGroup --output json)
$o=($json | ConvertFrom-Json)
$onDemandServer=$o.connectivityEndpoints.sqlOnDemand

Write-Host ("On demand server: {0}" -f $onDemandServer)
Write-Host "Setting the variable '$EndPointVariableName'"
[System.Environment]::SetEnvironmentVariable($EndPointVariableName,$onDemandServer, [System.EnvironmentVariableTarget]::User)
Write-Host "The variable '$EndPointVariableName' was set to the value '$onDemandServer'"


