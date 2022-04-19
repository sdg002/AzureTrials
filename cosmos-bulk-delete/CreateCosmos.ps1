. $PSScriptRoot\common.ps1

$Ctx=Get-AzContext
Write-Host  "Running in the context of $Ctx"
az group create --name $Global:CosmosResourceGroup --location  $Global:Location --subscription  $Ctx.Subscription.Id  | Out-Null


Write-Host "Testing for the presence of Cosmos account '$Global:CosmosAccountName' at the resource group '$Global:CosmosResourceGroup'"
$CosmosResource=Get-AzResource  -ResourceGroupName $Global:CosmosResourceGroup -ResourceType "Microsoft.DocumentDB/databaseAccounts" -Name $Global:CosmosAccountName -ErrorAction Continue
if ($null -eq $CosmosResource)
{
    Write-Host "No cosmos resource found at the specified resource group:'$Global:CosmosResourceGroup' and account name:'$Global:CosmosAccountName'"
    New-AzCosmosDBAccount -ResourceGroupName $Global:CosmosResourceGroup -Location $Global:Location  -EnableAnalyticalStorage $true -Name $Global:CosmosAccountName
}
else 
{
    Write-Host "Cosmos resource already exists at the specified resource group:'$Global:CosmosResourceGroup' and account name:'$Global:CosmosAccountName'"
}

$db=Get-AzCosmosDBSqlDatabase -ResourceGroupName $Global:CosmosResourceGroup -AccountName $Global:CosmosAccountName
if ($null -eq $db)
{
    Write-Host "No database by the name '$Global:CosmosResourceGroup' found in the account $Global:CosmosAccountName"
    New-AzCosmosDBSqlDatabase -ResourceGroupName $Global:CosmosResourceGroup -AccountName $Global:CosmosAccountName -Name $Global:CustomersManagementDatabase
}
else {
    Write-Host "Database by the name '$Global:CosmosResourceGroup' already exists in the account $Global:CosmosAccountName"
}

$customerContainer = Get-AzCosmosDBSqlContainer -ResourceGroupName $Global:CosmosResourceGroup -AccountName $Global:CosmosAccountName -DatabaseName $Global:CustomersManagementDatabase
if ($null -eq $customerContainer){
    Write-Host "Creating container $global:CustomersMasterContainer"
    New-AzCosmosDbSqlContainer -ResourceGroupName $Global:CosmosResourceGroup -AccountName $Global:CosmosAccountName -DatabaseName $Global:CustomersManagementDatabase -Name $global:CustomersMasterContainer -PartitionKeyPath "/id" -PartitionKeyKind Hash
}
else {
    Write-Host "Not creating container $global:CustomersMasterContainer because it already exists"
}

