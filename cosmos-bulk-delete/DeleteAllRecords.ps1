Set-StrictMode -Version "latest"
Clear-Host
. $PSScriptRoot\common.ps1

Write-Host "Getting Cosmos context"
$CosmosContext=New-CosmosDbContext -Database $Global:CustomersManagementDatabase -ResourceGroupName $Global:CosmosResourceGroup  -Account $Global:CosmosAccountName
Write-Host ("Got Cosmos context for Cosmos account: '{0}'  and database: '{1}'" -f $CosmosContext.Account, $CosmosContext.Database)


function GetAllDocuments {
    #Remember to include Partition key path in field list
    $allDocs = Get-CosmosDbDocument -CollectionId $Global:CustomersMasterContainer -QueryEnableCrossPartition $true -Query "SELECT c.id FROM c" -Context $CosmosContext
    if ($null -eq $allDocs)
    {
        return ,@()
    }
    return $allDocs
}

function  DeleteDocuments {
    param ($documents)
    foreach ($doc in $documents) {
        #Remember to specify Partition key
        Remove-CosmosDbDocument -Context $CosmosContext -CollectionId $Global:CustomersMasterContainer -Database $Global:CustomersManagementDatabase -Id $doc.id -PartitionKey $doc.id
    }
}
$documents=GetAllDocuments
Write-Host ("Found {0} documents in the Container {1}" -f $documents.length,$Global:CustomersMasterContainer)
DeleteDocuments -documents $documents
Write-Host "Deletion complete"
