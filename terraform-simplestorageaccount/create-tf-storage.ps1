Set-StrictMode -Version "Latest"
Clear-Host
$ErrorActionPreference="Stop"


$ResourceGroup="rg-demo-terraform-simple-storage-container"
$Location="uksouth"
$TerraformStorageAccountName="mydemotfstoragestate"
$TerraformStateContainer="tfstate"
#########################################################################
Write-Host "Creating resource group $ResourceGroup"
New-AzResourceGroup -Name $ResourceGroup -Location $Location -Force | Out-Null
Write-Host "Created resource group $ResourceGroup"

Write-Host "Creating storage account $TerraformStorageAccountName"
$tfStorageAccount=$null
$tfStorageAccount = Get-AzStorageAccount -Name $TerraformStorageAccountName -ResourceGroupName $ResourceGroup
if ($null -eq $tfStorageAccount)
{
    $tfStorageAccount=New-AzStorageAccount -ResourceGroupName $ResourceGroup -Name $TerraformStorageAccountName -Location $Location  -SkuName  "Standard_GRS"
    Write-Host "Created storage account $TerraformStorageAccountName, Kind={0}" -f $tfStoAccount.Kind
}
else 
{
    Write-Host "Not creating storage account $TerraformStorageAccountName because it already exists"
}

New-AzStorageContainer  -Name $TerraformStateContainer -Context $tfStorageAccount.Context -Permission Blob -ErrorAction SilentlyContinue
Write-Host "Storage container created "

Write-Host "Fetching TF state storage account key so that TERRAFORM INIT can be carried using environment variables"
$stoKeys=Get-AzStorageAccountKey -ResourceGroupName $ResourceGroup -Name $TerraformStorageAccountName
Write-Host "Displaying the storage account key. You should set the value of ARM_ACCESS_KEY"
Write-Host $stoKeys[0].Value


