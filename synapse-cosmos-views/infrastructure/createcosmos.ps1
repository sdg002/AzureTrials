Set-StrictMode -Version "latest"
Clear-Host
. $PSScriptRoot\common.ps1

$ErrorActionPreference="Stop"


New-AzResourceGroup -Name $Global:CosmosResourceGroup -Force -Location $Global:Location | Out-Null
Write-Host ("Resource group created '{0}' at location '{1}'" -f $Global:CosmosResourceGroup, $Global:Location)
#
#Create a new Cosmos
#
Write-Host "Testing for the presence of Cosmos account '$Global:CosmosAccountName' at the resource group '$Global:CosmosResourceGroup'"
$CosmosResource=Get-AzResource  -ResourceGroupName $Global:CosmosResourceGroup -ResourceType "Microsoft.DocumentDB/databaseAccounts"
if ($null -eq $CosmosResource)
{
    Write-Host "No cosmos resource found at the specified resource group:'$Global:CosmosResourceGroup' and account name:'$Global:CosmosAccountName'"
    New-AzCosmosDBAccount -ResourceGroupName $Global:CosmosResourceGroup -Location $Global:Location  -EnableAnalyticalStorage $true -Name $Global:CosmosAccountName
}
else 
{
    Write-Host "Cosmos resource already exists at the specified resource group:'$Global:CosmosResourceGroup' and account name:'$Global:CosmosAccountName'"
}

