Set-StrictMode -Version "latest"
Clear-Host
$ErrorActionPreference="Stop"

$ResourceGroup="rg-demo-rotation-storageaccount"
$DemoAccountName="demostoaccount001"
$Location="uksouth"
$KeyVaultName="Sau-MyKeyVaultName"

New-AzResourceGroup -Name $ResourceGroup -Force -Location $Location

$Resource=Get-AzResource -ResourceGroupName $ResourceGroup -Name $DemoAccountName
if ($null -eq $Resource)
{
    Write-Host ("The storage account with name {0} was not found" -f $DemoAccountName)
    New-AzStorageAccount -ResourceGroupName $ResourceGroup -Name $DemoAccountName   -SkuName "Standard_LRS" -Location $Location
}
else 
{
    Write-Host ("The storage account with name {0} already exists. Not creating again" -f $DemoAccountName)
}

$KeyVaultResource=Get-AzKeyVault -ResourceGroupName $ResourceGroup -VaultName $KeyVaultName
if ($null -eq $KeyVaultResource)
{
    Write-Host ("The KeyVault with name {0} was not found" -f $KeyVaultName)
    $KeyVaultResource=New-AzKeyVault -ResourceGroupName $ResourceGroup -Name $KeyVaultName -Location $Location
    Write-Host ("New key vault was created , URL={0}" -f  $KeyVaultResource.VaultUri)
}
else 
{
    Write-Host ("The KeyVault with name {0} already exists. Not creating again" -f $KeyVaultName)
    Write-Host ("URL={0}" -f  $KeyVaultResource.VaultUri)
}

