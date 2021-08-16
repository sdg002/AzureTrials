Set-StrictMode -Version "Latest"
Clear-Host
$ErrorActionPreference="Stop"

<#
I created a Cosmos account in Azure Portal and then downloaded the ARM template
I had to remove some of the properties during local deployment because Powershell complained that they were not supported in the curent schema
Tried tinkering with Schema but ended up removing some of the errant properties
With the benefit of hindsight, it might be easier to use the Powershell cmdlet to create a new Cosmos account
#>

$Location="uksouth"

$Environment=$env:Environment
#########################################
if ([string]::IsNullOrWhiteSpace($Environment))
{
    Write-Error -Message "The variable 'Environment' was not found"
}
$ResourceGroup="rg-demo-cosmos-$Environment"
$CosmosAccountName="mydemo001account-$Environment"
$context=Get-AzContext
#
Write-Host ("Current subscription '{0}'" -f $context.Subscription.Name)
Write-Host "Creating new resource group $ResourceGroup"
New-AzResourceGroup -Name $ResourceGroup -Force -Location $Location | Out-Null
#
#Deploy ARM template
#
$armFilePathPlan=Join-Path -Path $PSScriptRoot -ChildPath "armtemplate\template.json"

Write-Host "Deploying ARM template file $armFilePathPlan to $ResourceGroup"
$armFunctionPlanParameters=@{}
$armFunctionPlanParameters.Add("name",$CosmosAccountName)
$armFunctionPlanParameters.Add("location",$Location)
$armFunctionPlanParameters.Add("locationName",$Location)
$armFunctionPlanParameters.Add("defaultExperience","Core (SQL)")
$armFunctionPlanParameters.Add("isZoneRedundant","false")

New-AzResourceGroupDeployment -ResourceGroupName $ResourceGroup -TemplateFile $armFilePathPlan -TemplateParameterObject $armFunctionPlanParameters
Write-Host "Deploying ARM template file $armFilePathPlan to $ResourceGroup complete"


<#
How to enable analytical store using the CLI?
https://docs.microsoft.com/en-us/cli/azure/cosmosdb?view=azure-cli-latest#az_cosmosdb_update

#>