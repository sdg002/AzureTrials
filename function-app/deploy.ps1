Set-StrictMode -Version "Latest"
Clear-Host
$ErrorActionPreference="Stop"

$ResourceGroup="rg-demo-consumptionfunction-plan-and-app"
$Location="uksouth"
$PlanName="MyDemoPlanAndApp001"
$StorageAccountName="{0}sto" -f $PlanName.ToLower()
$FirstFunctionApp="mydemofunctionapp001"
$SecondFunctionApp="AnotherFunctionApp002"
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
Write-Host "Deploying function App $FirstFunctionApp"
$armFilePathApp=Join-Path -Path $PSScriptRoot -ChildPath "armtemplate\App.json"
$armFunctionAppParameters=@{}
$armFunctionAppParameters.Add("serverFarmResourceGroup",$ResourceGroup)
$armFunctionAppParameters.Add("subscriptionId",$context.Subscription.id)
$armFunctionAppParameters.Add("name",$FirstFunctionApp)
$armFunctionAppParameters.Add("location",$Location)
$armFunctionAppParameters.Add("hostingPlanName",$PlanName)
$armFunctionAppParameters.Add("alwaysOn",$false)
$armFunctionAppParameters.Add("storageAccountName",$StorageAccountName)
$armFunctionAppParameters.Add("use32BitWorkerProcess",$true)
$armFunctionAppParameters.Add("storageAccountConnectionString",$stoConnectionString)


Write-Host "Creating function app $FirstFunctionApp started"
New-AzResourceGroupDeployment -ResourceGroupName $ResourceGroup -TemplateFile $armFilePathApp -TemplateParameterObject $armFunctionAppParameters
Write-Host "Creating function app $FirstFunctionApp complete"
#
#Creating another function app using the same ARM template
#
$armFunctionAppParameters["name"]=$SecondFunctionApp
Write-Host "Creating function app $SecondFunctionApp started"
New-AzResourceGroupDeployment -ResourceGroupName $ResourceGroup -TemplateFile $armFilePathApp -TemplateParameterObject $armFunctionAppParameters
Write-Host "Creating function app $SecondFunctionApp complete"
#
#Update Config settings for App 1
#
Write-Host "Updating app setting for function app 1"
$configSettingsApp1 = @{}
$configSettingsApp1.Add("key2","value2-v2")

$configSettingsApp1.Add("key4","value4")
Update-AzFunctionAppSetting -ResourceGroupName $ResourceGroup -Name $FirstFunctionApp -AppSetting $configSettingsApp1
#
#Update Config settings for App 2
#
$configSettingsApp2 = @{}
$configSettingsApp2.Add("key2","value2-v2")
$configSettingsApp2.Add("key3","value2")
Update-AzFunctionAppSetting -ResourceGroupName $ResourceGroup -Name $SecondFunctionApp -AppSetting $configSettingsApp2
