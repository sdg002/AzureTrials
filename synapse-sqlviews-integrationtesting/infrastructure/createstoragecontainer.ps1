. $PSScriptRoot\common.ps1

Clear-Host
$Ctx=Get-AzContext
$CsvRecords=$null

function ReadCsv(){
    $metadataFile=Join-Path -Path $PSScriptRoot -ChildPath "storagemetadata.csv"    
    Write-Host "Reading metadata file $metadataFile"
    $global:CsvRecords=Import-Csv -Path $metadataFile

}
function CreateStorageContainer() {
    #az storage account create --name $Global:StorageAccountForCsv --resource-group $Global:SynapseResourceGroup --location $Global:Location --sku "Standard_LRS" --subscription $Ctx.Subscription.Id  | Out-Null
    Write-Host ("Found {0} records in the metadata file" -f $global:CsvRecords.Count)
    foreach($record in $global:CsvRecords){
        Write-Host "---------------------"
        Write-Host ("Container name: {0}" -f $record.ContainerName)
        Write-Host ("Table name: {0}" -f $record.TableName)
        Write-Host "Creating storage account"
        & az storage container create --name $record.ContainerName --account-name $Global:StorageAccountForCsv
        Write-Host "Storage account created"
        Write-Host "---------------------"
    }
}

function UploadFiles(){
    foreach($record in $global:CsvRecords){
        Write-Host "---------------------"
        $csvFile=Join-Path "$PSScriptRoot\samplecsv" -ChildPath $record.SampleCSV
        Write-Host ("Going to upload file {0} to the container {1}" -f $csvFile,$record.ContainerName)
        & az storage blob upload --container-name $record.ContainerName  --account-name $Global:StorageAccountForCsv --file $csvFile --overwrite true
        Write-Host "---------------------"
    }
}

ReadCsv
CreateStorageContainer
UploadFiles

