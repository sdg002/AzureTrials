Set-StrictMode -Version "Latest"
$ErrorActionPreference="Stop"
Clear-Host

function GetCosmosAccount([string]$cosmosaccountname)
{
    $CosmosResource=get-azresource | Where-Object { $_.ResourceName -eq $cosmosaccountname}
    if ($null -eq $CosmosResource)
    {
        Write-Error -Message "Could not find Cosmos account: $cosmosaccountname"
    }
    Write-Host ("Found Cosmos account:'$cosmosaccountname' at resource group:'{0}'" -f $CosmosResource.ResourceGroupName)
    $account=Get-AzCosmosDBAccount -ResourceGroupName $CosmosResource.ResourceGroupName -Name $cosmosaccountname
    Write-Verbose -Message "Account exists"
    return $CosmosResource
}

function ExecuteSql([System.Object]$synapseworkspace,[string]$serverlessdatabase,[string]$sql)
{
    $token = (Get-AzAccessToken -ResourceUrl https://database.windows.net).Token
    $cnstring=$synapseworkspace.ConnectivityEndpoints.sqlOnDemand
    Invoke-Sqlcmd -ServerInstance $cnstring -Database $serverlessdatabase -Query $sql -AccessToken $token -Verbose

}
function CreateSynapseCredential([string]$credentialname,[string]$cosmosaccountname,[System.Object]$synapseworkspace,[string]$serverlessdatabase)
{
    $CosmosResource=GetCosmosAccount -cosmosaccountname $cosmosaccountname
    $CosmosKeys=Get-AzCosmosDBAccountKey -ResourceGroupName $CosmosResource.ResourceGroupName -Name $CosmosResource.Name
    $ReadonlyKey=$CosmosKeys.SecondaryReadonlyMasterKey
    $TemplateFile=Join-Path -Path  $PSScriptRoot -ChildPath "..\sqlviews\CredentialsTemplate.sql"
    $TemplateFileContents=[System.IO.File]::ReadAllText($TemplateFile)
    $ModifiedTemplateContents=$TemplateFileContents
    $ModifiedTemplateContents=$ModifiedTemplateContents -replace "CREDENTIALNAME",$credentialname
    $ModifiedTemplateContents=$ModifiedTemplateContents -replace "COSMOSACCOUNTKEY",$ReadonlyKey

    ExecuteSql -synapseworkspace $synapseworkspace -serverlessdatabase $serverlessdatabase -sql $ModifiedTemplateContents
    Write-Host "Created credential $credentialname"
}


$CosmosAccount="democosmosquery123"
$SynapseWorkspaceName="armsynapse001fromwrkstn"
$SynapseWorkspaceObject=Get-AzSynapseWorkspace -Name $SynapseWorkspaceName
$ServerlessDatabaseName="myserverlessdb"
#$e.ConnectivityEndpoints.sqlOnDemand
CreateSynapseCredential -credentialname "mycosmoscredential" -cosmosaccount $CosmosAccount -synapseworkspace $SynapseWorkspaceObject -serverlessdatabase $ServerlessDatabaseName

