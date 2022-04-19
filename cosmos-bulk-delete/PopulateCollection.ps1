. $PSScriptRoot\common.ps1

Write-Host "Getting Cosmos context"
$CosmosContext=New-CosmosDbContext -Database $Global:CustomersManagementDatabase -ResourceGroupName $Global:CosmosResourceGroup  -Account $Global:CosmosAccountName
Write-Host ("Got Cosmos context for Cosmos account: '{0}'  and database: '{1}'" -f $CosmosContext.Account, $CosmosContext.Database)


$jsonFiles=Get-ChildItem -Path $PSScriptRoot\json\  -Filter *.json -Recurse
Write-Host ("Found {0} json files" -f  $jsonFiles.Length)
foreach ($jsonFile in $jsonFiles) {
    
    $docContents=[system.io.file]::ReadAllText($jsonFile)
    $jsonObject=$docContents | ConvertFrom-Json
    New-CosmosDbDocument -Context $CosmosContext -CollectionId $Global:CustomersMasterContainer -DocumentBody $docContents  -PartitionKey $jsonObject.id
    Write-Output "Created document from file $jsonFile"
}
