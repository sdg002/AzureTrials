. $PSScriptRoot\..\common\variables.ps1



$VaultName="saudemovault400"

$accountKeys = (& az storage account keys list --resource-group $Global:ResourceGroup --account-name section307 | ConvertFrom-Json -AsHashTable)
$key=$accountKeys[0]["value"]
Write-Host "Going to add the Storage account Key to the key vault $VaultName"
& az keyvault secret set --vault-name $VaultName --name "STORAGEACCOUNTKEY" --value $key
RaiseCliError -message "Failed to set secret in the key vault $VaultName"

