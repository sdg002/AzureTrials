. $PSScriptRoot\..\common\variables.ps1



$armTemplateFile=Join-Path -Path $PSScriptRoot -ChildPath "template.json"
$armParameterFile=Join-Path -Path $PSScriptRoot -ChildPath "parameters.json"

Write-Host "Going to create a storage account '$Global:StorageAccount' using ARM template $armTemplateFile"
& az deployment group create --resource-group $Global:ResourceGroup --template-file $armTemplateFile --parameters @$armParameterFile --verbose

# & az storage account create --resource-group $Global:ResourceGroup --name $Global:StorageAccount `
#     --location $Global:Location --sku $Global:StorageAccountSku `
#     --tags department=$Global:TagDepartment owner=$Global:TagOwner costcenter=$Global:TagCostCenter
RaiseCliError -message "Failed to deploy storage account $Global:StorageAccount"
