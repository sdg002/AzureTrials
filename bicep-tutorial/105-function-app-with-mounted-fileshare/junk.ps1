. $PSScriptRoot/../common.ps1
. $PSScriptRoot/variables.ps1

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
