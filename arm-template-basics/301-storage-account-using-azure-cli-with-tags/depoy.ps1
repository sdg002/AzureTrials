. $PSScriptRoot\..\common\variables.ps1



Write-Host "Going to create a storage account '$Global:StorageAccount' using Azure CLI only"

& az storage account create --resource-group $Global:ResourceGroup --name $Global:StorageAccount `
    --location $Global:Location --sku $Global:StorageAccountSku `
    --tags department=$Global:TagDepartment owner=$Global:TagOwner costcenter=$Global:TagCostCenter
RaiseCliError -message "Failed to deploy storage account $Global:StorageAccount"
