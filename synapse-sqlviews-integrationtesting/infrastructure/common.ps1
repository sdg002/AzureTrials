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
$Global:StorageBlobContributorRole="Storage Blob Data Contributor"

function ReplaceTextInFile([string]$sqlfilename,[System.Collections.Hashtable]$tagvalues)
{
    #
    #Reads the specified file and replaces the tags specified in the Keys of the HashTable with the corresponding values
    #The file is not modified. The replaced text is returned to the caller
    #
    $TemplateFileContents=[System.IO.File]::ReadAllText($sqlfilename)
    $ModifiedTemplateContents=$TemplateFileContents
    foreach ($key in $tagvalues.Keys) 
    {
        $tagValue=$tagvalues[$key]
        $ModifiedTemplateContents=$ModifiedTemplateContents -replace $key,$tagValue
    }
    return $ModifiedTemplateContents
}

function ThrowErrorIfExitCode($message){
    if (0 -eq $LASTEXITCODE){
        return
    }
    Write-Error -Message $message
}
