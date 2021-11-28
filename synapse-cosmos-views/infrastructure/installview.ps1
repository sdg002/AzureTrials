. $PSScriptRoot\common.ps1
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
    $results=Invoke-Sqlcmd -ServerInstance $cnstring -Database $serverlessdatabase -Query $sql -AccessToken $token -Verbose
    return $results
}
function GetSqlWithReplacedTags([string]$sqlfilename,[System.Collections.Hashtable]$tagvalues)
{
    $TemplateFile=Join-Path -Path  $PSScriptRoot -ChildPath "..\$sqlfilename"
    $TemplateFileContents=[System.IO.File]::ReadAllText($TemplateFile)
    $ModifiedTemplateContents=$TemplateFileContents
    # $ModifiedTemplateContents=$ModifiedTemplateContents -replace "CREDENTIALNAME",$credentialname
    # $ModifiedTemplateContents=$ModifiedTemplateContents -replace "COSMOSACCOUNTKEY",$ReadonlyKey
    foreach ($key in $tagvalues.Keys) 
    {
        $tagValue=$tagvalues[$key]
        $ModifiedTemplateContents=$ModifiedTemplateContents -replace $key,$tagValue
    }
    return $ModifiedTemplateContents
}

function GetSqlContentWithReplacedTags([string]$templatesqlcontents,[System.Collections.Hashtable]$tagvalues)
{
    $ModifiedTemplateContents=$templatesqlcontents
    foreach ($key in $tagvalues.Keys) 
    {
        $tagValue=$tagvalues[$key]
        $ModifiedTemplateContents=$ModifiedTemplateContents -replace $key,$tagValue
    }
    return $ModifiedTemplateContents
}

function CreateSynapseCredential([string]$credentialname,[string]$cosmosaccountname,[System.Object]$synapseworkspace,[string]$serverlessdatabase)
{
    $CosmosResource=GetCosmosAccount -cosmosaccountname $cosmosaccountname
    $CosmosKeys=Get-AzCosmosDBAccountKey -ResourceGroupName $CosmosResource.ResourceGroupName -Name $CosmosResource.Name
    $ReadonlyKey=$CosmosKeys.SecondaryReadonlyMasterKey

    $dict=@{}
    $dict.Add("CREDENTIALNAME",$credentialname)
    $dict.Add("COSMOSACCOUNTKEY",$ReadonlyKey)

    $TemplateFile=Join-Path -Path  $PSScriptRoot -ChildPath "..\credential\CredentialsTemplate.sql"
    $TemplateFileContents=[System.IO.File]::ReadAllText($TemplateFile)

    #$ModifiedTemplateContents =GetSqlWithReplacedTags -sqlfilename "credential\CredentialsTemplate.sql" -tagvalues $dict
    $ModifiedTemplateContents = GetSqlContentWithReplacedTags -templatesqlcontents $TemplateFileContents -tagvalues $dict

    ExecuteSql -synapseworkspace $synapseworkspace -serverlessdatabase $serverlessdatabase -sql $ModifiedTemplateContents
    Write-Host "Created credential $credentialname"
}

function CreateView([string]$viewfile,[string]$credentialname,[string]$cosmosaccountname,[System.Object]$synapseworkspace,[string]$serverlessdatabase,[string]$cosmosdatabase)
{
    $dict=@{}
    $dict.Add("CREDENTIALNAMETAG",$credentialname)
    $dict.Add("COSMOSACCOUNTNAMETAG",$cosmosaccountname)
    $dict.Add("DATABASENAMETAG",$cosmosdatabase)
    $TemplateContents=[System.IO.File]::ReadAllText($viewfile)
    $ModifiedTemplateContents =GetSqlContentWithReplacedTags -templatesqlcontents $TemplateContents -tagvalues $dict
    #GetSqlWithReplacedTags -sqlfilename $viewfile -tagvalues $dict
    ExecuteSql -synapseworkspace $synapseworkspace -serverlessdatabase $serverlessdatabase -sql $ModifiedTemplateContents
    Write-Host "Created view  $viewfile"
}

function CreateAllViews()
{
    $ViewsFolder=Join-Path -Path  $PSScriptRoot -ChildPath "..\sqlviews\"
    $allViewFiles=Get-ChildItem -Path $ViewsFolder -Filter "*.sql"
    foreach ($viewFile in $allViewFiles) 
    {
        CreateView -viewfile $viewFile.FullName -credentialname "mycosmoscredential" -cosmosaccountname $Global:CosmosAccountName -synapseworkspace $SynapseWorkspaceObject -serverlessdatabase $ServerlessDatabaseName -cosmosdatabase $Global:CustomersDatabase
    }
    
}

function  DropAllExistingViews([System.Object]$synapseworkspace,[string]$serverlessdatabase)
{
    $sqlToGetallViews="SELECT * FROM SYS.OBJECTS WHERE [type]='v'"
    $sqlResults=ExecuteSql -synapseworkspace $synapseworkspace -serverlessdatabase $serverlessdatabase -sql $sqlToGetallViews
    if ($null -eq $sqlResults)
    {
        Write-Host "No existing views found. Nothing to delete"
        return
    }
    Write-Host ("Found {0} existing views" -f $sqlResults.Length)

    foreach ($viewInfo in $sqlResults) 
    {
        $DropViewSql = ("DROP VIEW {0}"  -f $viewInfo.name )
        ExecuteSql -synapseworkspace $synapseworkspace -serverlessdatabase $serverlessdatabase -sql $DropViewSql
        Write-Host ("Dropped view {0}" -f $viewInfo.name)
    }
}
function RunSomeSampleQuery([System.Object]$synapseworkspace,[string]$serverlessdatabase)
{
    $results=ExecuteSql -synapseworkspace $synapseworkspace -serverlessdatabase $serverlessdatabase -sql "SELECT * FROM vwAllCustomers"
    $results
}

$SynapseWorkspaceName="armsynapse001fromwrkstn"
Write-Host "Starting..."
$SynapseWorkspaceObject=Get-AzSynapseWorkspace -Name $SynapseWorkspaceName
$ServerlessDatabaseName="myserverlessdb"
#$e.ConnectivityEndpoints.sqlOnDemand
DropAllExistingViews -synapseworkspace $SynapseWorkspaceObject -serverlessdatabase $ServerlessDatabaseName
CreateSynapseCredential -credentialname "mycosmoscredential" -cosmosaccount $Global:CosmosAccountName -synapseworkspace $SynapseWorkspaceObject -serverlessdatabase $ServerlessDatabaseName
CreateAllViews
RunSomeSampleQuery -synapseworkspace $SynapseWorkspaceObject -serverlessdatabase $ServerlessDatabaseName

