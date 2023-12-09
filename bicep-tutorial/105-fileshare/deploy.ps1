. $PSScriptRoot/../common.ps1
. $PSScriptRoot/variables.ps1


<#
Deploying Storage account
#>

Write-Host "Deploying storage account $Global:StorageAccount"
& az deployment group create --resource-group $Global:ResourceGroup `
    --template-file "$PSScriptRoot\templates\storage.bicep" `
    --parameters name=$Global:StorageAccount  --verbose
RaiseCliError -message "Failed to create the storage account $Global:StorageAccount"


<#
Deploying file share
#>
Write-Host "Deploying  File Share $Global:ShareName"
& az deployment group create --resource-group $Global:ResourceGroup `
    --template-file "$PSScriptRoot\templates\fileshare.bicep" `
    --parameters `
    storageaccount=$Global:StorageAccount `
    name=$Global:ShareName `
    --verbose
RaiseCliError -message "Failed to create file share $Global:ShareName"


