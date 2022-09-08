. $PSScriptRoot\common.ps1

Clear-Host



function UploadFile {
    param ([string]$container,[string]$filename)

    $csvFile=Join-Path "$PSScriptRoot" -ChildPath "../$filename"
    Write-Host ("Going to purge all files in container {0}" -f $container)
    & az storage blob delete-batch --source $container  --account-name $Global:StorageAccountForCsv --pattern *.*
    Write-Host "Uploaded file $filename to the container: $container"
    Write-Host ("Going to upload file {0} to the container {1}" -f $csvFile,$container)
    & az storage blob upload --container-name $container  --account-name $Global:StorageAccountForCsv --file $csvFile --overwrite true
    ThrowErrorIfExitCode -message "Failed to upload '$filename' to the container: '$container'"
    Write-Host "Uploaded file $filename to the container: $container"

}

UploadFile -container "address" -filename "samplecsv/address.csv"
UploadFile -container "people" -filename "samplecsv/people.csv"
