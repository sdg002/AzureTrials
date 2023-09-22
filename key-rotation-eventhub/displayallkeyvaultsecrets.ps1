. $PSScriptRoot\variables.ps1

<#
Helper script to display the values of all the secrets currently held in the Key Vault
#>
write-Host "Going to display all secrets that are held in the Key Vault $Global:KeyVault"

$secrets= (az keyvault secret list  --vault-name $Global:KeyVault | ConvertFrom-Json) 

$secrets =  ($null -eq $secrets) ? @() : $secrets
Write-Host "Found $($secrets.length) secrets"
foreach ($secret in $secrets)
{
    Write-Host "Fetching the secret value of $($secret.name)"
    $secretJson=(az keyvault secret show --name $secret.name --vault-name $Global:KeyVault | ConvertFrom-Json)
    $secretJson.value
    Write-Host "---------------------------------------"
}

$secrets | Format-Table
