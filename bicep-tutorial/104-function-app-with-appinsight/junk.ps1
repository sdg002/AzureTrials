. $PSScriptRoot/../common.ps1
. $PSScriptRoot/variables.ps1

<#
Deploy App Service Plan
#>
Write-Host "Deploying storage container  $Global:FunctionStorageCustomContainer in the storage account $Global:FunctionStorageAccount"
& az deployment group create --resource-group $Global:ResourceGroup `
    --template-file "$PSScriptRoot\templates\storagecontainer.bicep" `
    --parameters storageaccount=$Global:FunctionStorageAccount `
    name=$Global:FunctionStorageCustomContainer `
    --verbose
RaiseCliError -message "Failed to deploy storage container plan $Global:FunctionStorageCustomContainer"
