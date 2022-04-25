Set-StrictMode -Version "latest"
$ErrorActionPreference="Stop"

$environment=$env:environment
if ([string]::IsNullOrWhiteSpace($environment)){
    Write-Error -Message "The variable 'environment' was empty. Should be set to dev or uat or prod"
}

$Global:SynapseResourceGroup="rg-demo-synapse-integration-testing"
$Global:Location="uksouth"
$Global:StorageAccountForCsv="csvstoragedemo001"
$Global:SynapseWorkspaceName="testsynapse-$env:environment"
$Global:SynapseAdminUser="synapseadmin"
$Global:SynapseFileShare="testsynapsefileshare"