Set-StrictMode -Version "latest"
Clear-Host
$ErrorActionPreference="Stop"

$ResourceGroup="rg-demo-synapse-cosmos"
$KeyVaultName="Demo-MyKeyVaultName"
$Location="uksouth"
New-AzResourceGroup -Name $ResourceGroup -Force -Location $Location | Out-Null


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
