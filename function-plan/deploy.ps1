Set-StrictMode -Version "Latest"
Clear-Host
$ErrorActionPreference="Stop"

$ResourceGroup="rg-demo-consumptionfunction-plan"
$Location="uksouth"
$PlanName="MyDemoPlan001"
#########################################
#
Write-Host "Creating new resource group $ResourceGroup"
New-AzResourceGroup -Name $ResourceGroup -Force -Location $Location | Out-Null
#
#Deploy ARM template
#
$armFilePath=Join-Path -Path $PSScriptRoot -ChildPath "armtemplate\ConsumptionPlan.json"
Write-Host "Deploying ARM template file $armFilePath to $ResourceGroup"
$armParameters=@{}
$armParameters.Add("appName",$PlanName)
New-AzResourceGroupDeployment -ResourceGroupName $ResourceGroup -TemplateFile $armFilePath -TemplateParameterObject $armParameters
Write-Host "Deploying ARM template file $armFilePath to $ResourceGroup complete"