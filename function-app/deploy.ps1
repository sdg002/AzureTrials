Set-StrictMode -Version "Latest"
Clear-Host
$ErrorActionPreference="Stop"

$ResourceGroup="rg-demo-consumptionfunction-plan-and-app"
$Location="uksouth"
$PlanName="MyDemoPlanAndApp001"
$StorageAccountName="{0}sto" -f $PlanName.ToLower()
$FunctionApp="mydemofunctionapp001"
#########################################
$context=Get-AzContext
#
Write-Host "Creating new resource group $ResourceGroup"
New-AzResourceGroup -Name $ResourceGroup -Force -Location $Location | Out-Null
#
#Deploy ARM template
#
$armFilePathPlan=Join-Path -Path $PSScriptRoot -ChildPath "armtemplate\ConsumptionPlan.json"
Write-Host "Deploying ARM template file $armFilePathPlan to $ResourceGroup with storage account $StorageAccountName"
$armFunctionPlanParameters=@{}
$armFunctionPlanParameters.Add("appName",$PlanName)
$armFunctionPlanParameters.Add("appStorageAccountName",$StorageAccountName)
New-AzResourceGroupDeployment -ResourceGroupName $ResourceGroup -TemplateFile $armFilePathPlan -TemplateParameterObject $armFunctionPlanParameters
Write-Host "Deploying ARM template file $armFilePathPlan to $ResourceGroup complete"
#
#Deploy the function app
#
$stoKeys=Get-AzStorageAccountKey -ResourceGroupName  $ResourceGroup -Name $StorageAccountName
$stoKeyValue=$stoKeys[0].Value
$stoConnectionString="DefaultEndpointsProtocol=https;AccountName=$StorageAccountName;AccountKey=$stoKeyValue;EndpointSuffix=core.windows.net"
Write-Host "Got connection string of Storage account $StorageAccountName"
#
Write-Host "Deploying function App $FunctionApp"
$armFilePathApp=Join-Path -Path $PSScriptRoot -ChildPath "armtemplate\App.json"
$armFunctionAppParameters=@{}
$armFunctionAppParameters.Add("serverFarmResourceGroup",$ResourceGroup)
$armFunctionAppParameters.Add("subscriptionId",$context.Subscription.id)
$armFunctionAppParameters.Add("name",$FunctionApp)
$armFunctionAppParameters.Add("location",$Location)
$armFunctionAppParameters.Add("hostingPlanName",$PlanName)
$armFunctionAppParameters.Add("alwaysOn",$false)
$armFunctionAppParameters.Add("storageAccountName",$StorageAccountName)
$armFunctionAppParameters.Add("use32BitWorkerProcess",$true)
$armFunctionAppParameters.Add("storageAccountConnectionString",$stoConnectionString)




New-AzResourceGroupDeployment -ResourceGroupName $ResourceGroup -TemplateFile $armFilePathApp -TemplateParameterObject $armFunctionAppParameters
Write-Host "Deploying ARM template file $armFilePathApp to $ResourceGroup complete"
