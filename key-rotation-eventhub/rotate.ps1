param(
    [Parameter(Mandatory)][string]$rg,
    [Parameter(Mandatory)][string]$eventhub, 
    [Parameter(Mandatory)][string]$keyvault,
    [Parameter(Mandatory)][string]$secret
    )

Write-host "Event hub key rotation script '$rg', '$eventhub',  '$keyvault', '$secret'"

Write-Host "Going to get the secret $secret from the key vault $keyvault"
$currentSecret=Get-AzKeyVaultSecret -VaultName $keyvault -SecretName $secret -AsPlainText
Write-Host "Got the secret $currentSecret"

Write-Host "Going to get the connection strings of Event Hub $eventhub"
$keys=Get-AzEventHubKey -Namespace $Global:EventHubNameSpace -ResourceGroupName $global:ResourceGroup -Name RootManageSharedAccessKey
Write-Host "Got to get the connection strings of Event Hub $eventhub  ,$keys"

$secretPrimary = $keys.PrimaryConnectionString
$secretSecondary = $keys.SecondaryConnectionString
$whichSecretToRotate=$null

if ($currentSecret -eq $secretPrimary)
{
    $whichSecretToRotate="SecondaryKey" 
}
else{
    $whichSecretToRotate="PrimaryKey" 
}

Write-Host "Going to re-generate  '$whichSecretToRotate' "
$newKeys=New-AzEventHubKey -Namespace $eventhub -ResourceGroupName $rg -Name RootManageSharedAccessKey -KeyType $whichSecretToRotate -Verbose

$newKeyVaultSecret=$null
if ($whichSecretToRotate -eq "PrimaryKey")
{
    $newKeyVaultSecret=$newKeys.PrimaryConnectionString
}
else 
{
    $newKeyVaultSecret=$newKeys.SecondaryConnectionString    
}
Write-Host "Going to set the secret '$newKeyVaultSecret'"
$SecretConverted = ConvertTo-SecureString -String $newKeyVaultSecret  -AsPlainText -Force
Set-AzKeyVaultSecret -VaultName $keyvault -Name $secret -SecretValue  $SecretConverted
<#

Inputs:
-------
key vault name
secret name
event hub name

Expected
--------
Get current secret value 
Get current connection strings from Event hub (primary and secondary)

if (current_secret=primary)
{
    regenerate secondary
    update secret with new seconday
}
else
{
    regnerate primary
    update secret with new primary
}

#>

