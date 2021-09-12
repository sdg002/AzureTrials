Set-StrictMode -Version "latest"
Clear-Host
$ErrorActionPreference="Stop"

$ResourceGroup="rg-demo-synapse-cosmos"
$CosmosAccountName="mydemo001account-$Environment"
$Location="uksouth"

New-AzResourceGroup -Name $ResourceGroup -Force -Location $Location | Out-Null
#
#Create a new Cosmos
#
Write-Host "Testing for the presence of Cosmos account '$CosmosAccountName' at the resource group '$ResourceGroup'"
$CosmosResource=Get-AzResource  -ResourceGroupName $ResourceGroup -ResourceType "Microsoft.DocumentDB/databaseAccounts" -Name $CosmosAccountName
if ($null -eq $CosmosResource)
{
    Write-Host "No cosmos resource found at the specified resource group:'$ResourceGroup' and account name:'$CosmosAccountName'"
    New-AzCosmosDBAccount -ResourceGroupName $ResourceGroup -Location $Location  -EnableAnalyticalStorage $true -Name $CosmosAccountName
}
else 
{
    Write-Host "Cosmos resource already exists at the specified resource group:'$ResourceGroup' and account name:'$CosmosAccountName'"
}

