. $PSScriptRoot/variables.ps1

<#
Script for deploying all Azure resources neccessary for a Python Flask Web apps
#>

<#
Deploy resource group
#>
Write-Host "Going to create the resource group: '$Global:ResourceGroup' with the location: '$Global:Location' "
& az group create --location $Global:Location --name $Global:ResourceGroup `
    --tags department=$Global:TagDepartment owner=$Global:TagOwner costcenter=$Global:TagCostCenter
RaiseCliError -message "Failed to create the resource group $Global:ResourceGroup"


Write-Host "Deploying storage account $Global:StorageAccount"
$file="C:\Users\saurabhd\MyTrials\AzureStuff\AzureTrials\AzureTrials\bicep-tutorial\templates\storage.bicep"
& az deployment group create --resource-group $Global:ResourceGroup `
    --template-file $file `
    --parameters name=$Global:StorageAccount  --verbose
RaiseCliError -message "Failed to create the storage account $Global:StorageAccount"


