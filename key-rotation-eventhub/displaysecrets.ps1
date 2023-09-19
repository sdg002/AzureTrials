. $PSScriptRoot\variables.ps1

<#
Helper script to display the values of all the secrets currently held in the Key Vault
#>
write-Host "Going to display all secrets that are held in the Key Vault $Global:KeyVault"

$secrets= (az keyvault secret list  --vault-name $Global:KeyVault | ConvertFrom-Json) 

$secrets =  ($null -eq $secrets) ? @() : $secrets
foreach ($secret in $secrets)
{
    Write-Host "Fetching the secret value of $($secret.name)"
    az keyvault secret show --name $secret.name --vault-name $Global:VaultName
}

$secrets
