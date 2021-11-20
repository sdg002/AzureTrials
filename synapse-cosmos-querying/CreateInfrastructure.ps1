Set-StrictMode -Version "latest"
Clear-Host
$ErrorActionPreference="Stop"

$ResourceGroup="rg-demo-synapse-cosmos"
$Location="uksouth"
$Environment="dev"
$CosmosAccountName="mydemo001account-$Environment"
$SynapseStoAccountName="demosynapse$environment"
$AdminADGroup="demosynapseadmingroup$environment"
$SynapseWorkspaceName="my-demo0synapse-$environment"
$SqlAdminUserName="demo-synapse-admin"
$SqlPassword="Pass@word123"
$SynapseFileShare="SynapseDemosynapsefileshare"
$FireWallRuleName="AllowAllAccess"

function ValidateEnvironmentVariables()
{
    Write-Host "Ensure all required environment variables have been defined, before going too far down the line"
}

function CreateResourceGroup()
{
    Write-Host   "Creating resource group $ResourceGroup"
    New-AzResourceGroup -Name $ResourceGroup -Force -Location $Location | Out-Null    
}

function CreateDataLakeStorageAccount()
{
    Write-Host "Checking for the existence of Storage account '$SynapseStoAccountName'"

    $existingAccount=Get-AzResource -ResourceGroupName $ResourceGroup -Name $SynapseStoAccountName

    if ($null -ne $existingAccount)
    {
        "The Storage account '$SynapseStoAccountName' already exists. Not creating"
        return
    }
    Write-Host "Going to create new Storage account with '$SynapseStoAccountName'"
    New-AzStorageAccount -ResourceGroupName $resourcegroup -Location $Location -SkuName Standard_RAGRS  -Kind StorageV2 -Name $SynapseStoAccountName
    Write-Host "Storage account '$SynapseStoAccountName' created"
}
function CreateADGroup () 
{
    $existingGroup=Get-AzADGroup -DisplayName $AdminADGroup        
    if ($null -ne $existingGroup)
    {
        Write-Host "AD group '$AdminADGroup' already exists. Not creating"
        return
    }
    New-AzADGroup -DisplayName $AdminADGroup -MailNickname $AdminADGroup -Description "Admin group for the Synapse resource '$SynapseWorkspaceName'"
    Write-Host "Created new AD group '$AdminADGroup'"
}
function AddCurrentUserToADGroup()
{
    Write-Host "Adding the current user to the AD group $AdminADGroup"
    $sp=Get-AzADServicePrincipal -ApplicationId $ctx.Account.id
    Write-Host ("Current service principal object id is {0}" -f $sp.Id)
    Add-AzADGroupMember -TargetGroupDisplayName $AdminADGroup -MemberObjectId $sp.Id -Verbose -ErrorAction Continue
    Write-Host "Added the user $($sp.Id) to the AD group $AdminADGroup"
}
function CreateSynapseStudio()
{
    $existingSynapseInstance=Get-AzResource -ResourceGroupName $ResourceGroup -Name $SynapseWorkspaceName
    if ($null -ne $existingSynapseInstance)
    {
        Write-Host "Not creating new Synapse because $SynapseWorkspaceName already exists"
        return
    }
    Write-Host "Going to create new Synapse Workspace '$SynapseWorkspaceName'"

    $Cred = New-Object -TypeName System.Management.Automation.PSCredential ($SqlAdminUserName, (ConvertTo-SecureString $SqlPassword -AsPlainText -Force))

    $WorkspaceParams = 
    @{
        Name = $SynapseWorkspaceName
        ResourceGroupName = $ResourceGroup
        DefaultDataLakeStorageAccountName = $SynapseStoAccountName
        DefaultDataLakeStorageFilesystem = $SynapseFileShare
        SqlAdministratorLoginCredential = $Cred
        Location = $Location
    }

    New-AzSynapseWorkspace @WorkspaceParams
    Write-Host "New Synapse instance $
    SynapseWorkspaceName was created"


}
function SetSynapseAdmin() 
{
    Write-Host "Setting Synapse admin to the AD group '$AdminADGroup'"
    $group=Get-AzADGroup -DisplayName $AdminADGroup
    Set-AzSynapseSqlActiveDirectoryAdministrator -ResourceGroupName $ResourceGroup -WorkspaceName $SynapseWorkspaceName -ObjectId $group.Id | Out-Null
    Write-Host "The AD group '$AdminADGroup' was made as the Administrator of the Synapse workspace '$SynapseWorkspaceName'"
}

function RelaxFireWallRules()
{
    Write-Host "Relaxing firewall rules"
    $existingRules=Get-AzSynapseFirewallRule -ResourceGroupName  $ResourceGroup -WorkspaceName $SynapseWorkspaceName
    foreach ($existingRule in $existingRules) {
        $startIP=$existingRule.StartIpAddress
        $endIP=$existingRule.EndIpAddress
        if (($startIP -eq "0.0.0.0" ) -and ($endIP -eq "255.255.255.255"))
        {
            Write-Host "Found existing rule which allows all IP addresses. Not processing any further"
            return
        }
    }
    #The cmdlet  Get-AzSynapseFirewallRule does not emit the Name attribute, therefore we have to take the defensive approach of ErorAction=Continue because the rule may or may not exist
    Remove-AzSynapseFirewallRule -ResourceGroupName $ResourceGroup -WorkspaceName $SynapseWorkspaceName -Name $FireWallRuleName -ErrorAction Continue -Force
    New-AzSynapseFirewallRule -ResourceGroupName $ResourceGroup -WorkspaceName $SynapseWorkspaceName -Name $FireWallRuleName -StartIpAddress "0.0.0.0" -EndIpAddress "255.255.255.255"
    Write-Host "Added relaxed firewall rules to allow script to work"
}
function CreateServerlessDatabase()
{
    Write-Host "Going to run SQL command to create a database"
    $access_token = (Get-AzAccessToken -ResourceUrl https://database.windows.net).Token
    $workspace=Get-AzSynapseWorkspace -ResourceGroupName $ResourceGroup -Name $SynapseWorkspaceName
    $pathToSql=Join-Path -Path $PSScriptRoot -ChildPath ".\sql\CreateServerlessDatabase.sql"
    Write-Host "Going to execute SQL file '$pathToSql' to create new database"
    Invoke-Sqlcmd -ServerInstance $workspace.ConnectivityEndpoints.sqlOnDemand  -AccessToken $access_token -InputFile $pathToSql -Database "MASTER" -Verbose
    Write-Host "SQL file executed. New database created"
}

ValidateEnvironmentVariables
CreateResourceGroup
CreateDataLakeStorageAccount
CreateADGroup
AddCurrentUserToADGroup
CreateSynapseStudio
SetSynapseAdmin
RelaxFireWallRules
CreateServerlessDatabase

<#
You have created Cosmos
Now create Azure Synapse
Done-Split Cosmos creation and Syanpse creation into 2 scripts 
Done-Create Key Vault in separate script (possibly with Cosmos)
Done-Create AD group
Done-Create storage accounts
Done-Create Synapse
Done-Create AD group
Done-Relax firewall rules
Done-Create new serverless datbase
Create new credential using SQL file (NOT GETTING THE RIGHT PERMISSIONS, TRIED ADDING TO SYNAPSE ADMINISTRATOR)
Create new view using SQL file
Test new SQL file using Invoke-SqlCommand
Try dropping all the views
Add password to KeyVault
Create database in in memory pool
Generate new password
Synapse admin role permissions
Done-Improve on creating new firewall rule
#>






