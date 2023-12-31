. $PSScriptRoot/../common.ps1
. $PSScriptRoot/variables.ps1

<#
Script for deploying all Azure resources neccessary for a Python Flask Web apps
#>


<#
Apply tags only
#>
& az group update  --resource-group $Global:ResourceGroup `
    --tags $Global:TagsArray
RaiseCliError -message "Failed to apply tas on the resource group $Global:ResourceGroup"


Write-Host "Deploying storage account $Global:StorageAccount"
& az deployment group create --resource-group $Global:ResourceGroup `
    --template-file "$PSScriptRoot\templates\storage.bicep" `
    --parameters name=$Global:StorageAccount  --verbose
RaiseCliError -message "Failed to create the storage account $Global:StorageAccount"


Write-Host "Deploying VNET $Global:Vnet"
& az deployment group create --resource-group $Global:ResourceGroup `
    --template-file "$PSScriptRoot\templates\network.bicep" `
    --parameters name=$Global:Vnet  --verbose
RaiseCliError -message "Failed to deploy VNET $Global:Vnet"


<#
Deploying function app with VNET for outbound
#>
Write-Host "Deploying  Function App $Global:FirstFunctionApp"
& az deployment group create --resource-group $Global:ResourceGroup `
    --template-file "$PSScriptRoot\templates\functionapp.bicep" `
    --parameters name=$Global:FirstFunctionApp `
    storageaccount=$Global:FunctionStorageAccount `
    planname=$Global:AppPlan `
    appinsight=$Global:ApplicationInsights `
    vnet=$Global:Vnet `
    subnet=$Global:Subnet  `
    --verbose
RaiseCliError -message "Failed to create function app $Global:FirstFunctionApp"
