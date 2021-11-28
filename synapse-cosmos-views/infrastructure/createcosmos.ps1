Set-StrictMode -Version "latest"
Clear-Host
. $PSScriptRoot\common.ps1

$ErrorActionPreference="Stop"



function CreateResourceGroup()
{
    New-AzResourceGroup -Name $Global:CosmosResourceGroup -Force -Location $Global:Location | Out-Null
    Write-Host ("Resource group created '{0}' at location '{1}'" -f $Global:CosmosResourceGroup, $Global:Location)    
}

#
#Create a new Cosmos account if it does not exist
#
function CreateCosmosAccount()
{
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
}
function CreateDatabase()
{
    $db=Get-AzCosmosDBSqlDatabase -ResourceGroupName $Global:CosmosResourceGroup -AccountName $Global:CosmosAccountName -Name $Global:CustomersManagementDatabase -ErrorAction SilentlyContinue
    if ($null -eq $db)
    {
        Write-Host ("Database '{0}' not found. Going to create." -f $Global:CustomersManagementDatabase)
        New-AzCosmosDBSqlDatabase -ResourceGroupName $Global:CosmosResourceGroup -AccountName $Global:CosmosAccountName -Name $Global:CustomersManagementDatabase
        Write-Host ("Customers database '{0}' created" -f $Global:CustomersManagementDatabase)
    }
    else 
    {
        Write-Host ("Database '{0}' already exists. Not going to create." -f $Global:CustomersManagementDatabase)
    }
}
function CreateContainer([string]$containername) 
{
    $containerObject=Get-AzCosmosDBSqlContainer -ResourceGroupName $Global:CosmosResourceGroup -AccountName $Global:CosmosAccountName -DatabaseName $Global:CustomersManagementDatabase -Name $containername
    if ($null -ne $containerObject)
    {
        Write-Host "The container '$containername' already exists"
    }
    else 
    {
        Write-Host ("Creating container '$containername'" )    
        New-AzCosmosDBSqlContainer -ResourceGroupName $Global:CosmosResourceGroup -AccountName $Global:CosmosAccountName -DatabaseName $Global:CustomersManagementDatabase -Name $Global:CustomersMasterContainer -PartitionKeyPath "/id" -PartitionKeyKind Hash
    }
    Write-Host "Updating the throughput of the container '$containername' to $Global:Throughput"
    Update-AzCosmosDBSqlContainer -ResourceGroupName $Global:CosmosResourceGroup -AccountName $Global:CosmosAccountName -DatabaseName $Global:CustomersManagementDatabase  -Name $containername -Throughput $Global:Throughput | Out-Null
}

CreateResourceGroup
CreateCosmosAccount
CreateDatabase
CreateContainer -containername "customersmaster"
