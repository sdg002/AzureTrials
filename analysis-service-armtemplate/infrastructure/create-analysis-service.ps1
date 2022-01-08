Set-StrictMode -Version "latest"
Clear-Host
$ErrorActionPreference="Stop"

$ResourceGroup="rg-demo-analysis-service"
$serviceName="demosaas001"
$Location="uksouth"
$Sku="D1" #determines the hardware spec
$armFile=Join-Path -Path $PSScriptRoot -ChildPath ".\arm.json"
$currentUser="saurabh_dasgupta_hotmail.com#EXT#@saurabhdasguptahotmail.onmicrosoft.com"

New-AzResourceGroup -Name $ResourceGroup -Force -Location $Location | Out-Null
"Resource group $ResourceGroup created or already exists"

$armParameters=@{
    "name"=$serviceName;
    "location"=$Location;
    "sku"=$Sku;
    "admin"=$currentUser;
    "backupBlobContainerUri"="";
    "managedMode"=1
}

Write-Host "Testing the deployment"
Test-AzResourceGroupDeployment -ResourceGroupName $ResourceGroup -TemplateFile $armFile -TemplateParameterObject $armParameters

$deploymentName=("sasdeployment-{0}" -f (Get-Date).Ticks)
Write-Host "Deployment start"
New-AzResourceGroupDeployment -ResourceGroupName $ResourceGroup -TemplateFile $armFile -TemplateParameterObject $armParameters -Name $deploymentName -Verbose
Write-Host "Deployment complete"
Suspend-AzAnalysisServicesServer -ResourceGroupName $ResourceGroup -Name $serviceName


