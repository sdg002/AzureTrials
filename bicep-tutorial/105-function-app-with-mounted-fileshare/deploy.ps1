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


<#
the following works, but you will need to use 'update' command during subsequent invocations
$AZURE_STORAGE_KEY="****"
& az webapp config storage-account add `
    --resource-group $Global:ResourceGroup `
    --name $Global:FirstFunctionApp `
    --custom-id "mydemofileshare-id" `
    --storage-type AzureFiles `
    --share-name $Global:ShareName `
    --account-name $Global:StorageAccount `
    --mount-path "/hello" `
    --access-key $AZURE_STORAGE_KEY    
RaiseCliError -message "Failed to mount file share $Global:ShareName to the function app $Glboal:FirstFunctionApp"
#>

Write-Host "Mounting file share to the function app $Global:FirstFunctionApp"
& az deployment group create --resource-group $Global:ResourceGroup `
    --template-file "$PSScriptRoot\templates\functionfileshare.bicep" `
    --parameters `
    storageaccount=$Global:StorageAccount `
    mountPath="/hello123" `
    azureShareName=$Global:ShareName `
    functionapp=$Global:FirstFunctionApp `
    --verbose
RaiseCliError -message "Failed to mount file share"
