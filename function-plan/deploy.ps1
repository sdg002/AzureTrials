Set-StrictMode -Version "Latest"
Clear-Host
$ErrorActionPreference="Stop"

$ResourceGroup="rg-demo-consumptionfunction-plan"
$Location="uksouth"
$PlanName="MyDemoPlan001"
$StorageAccountName="{0}sto" -f $PlanName.ToLower()
#########################################
#
Write-Host "Creating new resource group $ResourceGroup"
New-AzResourceGroup -Name $ResourceGroup -Force -Location $Location | Out-Null
#
#Deploy ARM template
#
$armFilePath=Join-Path -Path $PSScriptRoot -ChildPath "armtemplate\ConsumptionPlan.json"
Write-Host "Deploying ARM template file $armFilePath to $ResourceGroup with storage account $StorageAccountName"
$armParameters=@{}
$armParameters.Add("appName",$PlanName)
$armParameters.Add("appStorageAccountName",$StorageAccountName)
New-AzResourceGroupDeployment -ResourceGroupName $ResourceGroup -TemplateFile $armFilePath -TemplateParameterObject $armParameters
Write-Host "Deploying ARM template file $armFilePath to $ResourceGroup complete"
