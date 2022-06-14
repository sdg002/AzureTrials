. $PSScriptRoot\common.ps1

$Ctx=Get-AzContext
$FireWallRuleName="AllowAllAccess"
$AccessToken = (Get-AzAccessToken -ResourceUrl https://database.windows.net).Token
$SeverlessDatabaseName="myserverlessdb"


function CreateResourceGroup {
    Write-Host "Creating resource group $Global:SynapseResourceGroup"
    az group create --name $Global:SynapseResourceGroup --location  $Global:Location --subscription  $Ctx.Subscription.Id  | Out-Null
    ThrowErrorIfExitCode -Message "Could not create resource group $Global:SynapseResourceGroup"
}

function CreateStorageAccountForCsv{
    Write-Host "Creating storage account $Global:StorageAccountForCsv"
    az storage account create --name $Global:StorageAccountForCsv --resource-group $Global:SynapseResourceGroup --location $Global:Location --sku "Standard_LRS" --subscription $Ctx.Subscription.Id | Out-Null
    ThrowErrorIfExitCode -Message "Could not create storage account $Global:StorageAccountForCsv"
}

function DeploySynapse{
    $stoAccountForSynapse="synasepstorage{0}" -f $env:environment
    $synapsePassWord="Pass@word123"
    Write-Host "Creating storage account for Synapse $stoAccountForSynapse"
    & az storage account create --name $stoAccountForSynapse --resource-group $Global:SynapseResourceGroup --location $Global:Location --sku "Standard_LRS" --subscription $Ctx.Subscription.Id | Out-Null
    ThrowErrorIfExitCode -Message "Could not create storage account $stoAccountForSynapse"
    Write-Host "Creating Synapse workspace"
    & az synapse workspace create --name $Global:SynapseWorkspaceName --location $Global:Location --storage-account $stoAccountForSynapse --sql-admin-login-user $Global:SynapseAdminUser --sql-admin-login-password $synapsePassWord --file-system $Global:SynapseFileShare --subscription $Ctx.Subscription.Id --resource-group $Global:SynapseResourceGroup
    ThrowErrorIfExitCode -Message "Could not create synapse workspace  $Global:SynapseWorkspaceName"

}

function ThrowErrorIfExitCode($message){
    if (0 -eq $LASTEXITCODE){
        return
    }
    Write-Error -Message $message
}

function RelaxFireWallRules()
{
    Write-Host "Relaxing firewall rules"
    $existingRules=Get-AzSynapseFirewallRule -ResourceGroupName  $Global:SynapseResourceGroup -WorkspaceName $Global:SynapseWorkspaceName
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
    Remove-AzSynapseFirewallRule -ResourceGroupName $Global:SynapseResourceGroup -WorkspaceName $Global:SynapseWorkspaceName -Name $FireWallRuleName -ErrorAction Continue -Force
    New-AzSynapseFirewallRule -ResourceGroupName $Global:SynapseResourceGroup -WorkspaceName $Global:SynapseWorkspaceName -Name $FireWallRuleName -StartIpAddress "0.0.0.0" -EndIpAddress "255.255.255.255"
    Write-Host "Added relaxed firewall rules to allow script to work"
}

function CreateServerlessDatabase()
{
    Write-Host "Going to run SQL command to create a database"
    
    $workspace=Get-AzSynapseWorkspace -ResourceGroupName $Global:SynapseResourceGroup -Name $Global:SynapseWorkspaceName
    $pathToSql=Join-Path -Path $PSScriptRoot -ChildPath "new-serverless-database.sql"
    Write-Host "Going to execute SQL file '$pathToSql' to create new database"
    Invoke-Sqlcmd -ServerInstance $workspace.ConnectivityEndpoints.sqlOnDemand  -AccessToken $AccessToken -InputFile $pathToSql -Database "MASTER" -Verbose
    Write-Host "SQL file executed. New database created"
}

function CreateMasterKey(){
    #This is a 1 time step for every SQL Server - you need this for creating a credential - but do we need it if we are using managed identity
    Write-Host "Going to run SQL script to create master key"
    $workspace=Get-AzSynapseWorkspace -ResourceGroupName $Global:SynapseResourceGroup -Name $Global:SynapseWorkspaceName
    $pathToSql=Join-Path -Path $PSScriptRoot -ChildPath "sql/createmasterkey.sql"
    Write-Host "Going to execute SQL file '$pathToSql' to create new database"
    Invoke-Sqlcmd -ServerInstance $workspace.ConnectivityEndpoints.sqlOnDemand  -AccessToken $AccessToken -InputFile $pathToSql -Database $SeverlessDatabaseName -Verbose
    Write-Host "SQL file executed. New database created"
}

function CreatePeopleCredential(){
    Write-Host "Going to run SQL script to create credential"
    $workspace=Get-AzSynapseWorkspace -ResourceGroupName $Global:SynapseResourceGroup -Name $Global:SynapseWorkspaceName
    $pathToSql=Join-Path -Path $PSScriptRoot -ChildPath "sql/peoplecredential.sql"
    Write-Host "Going to execute SQL file '$pathToSql' to create new database"
    Invoke-Sqlcmd -ServerInstance $workspace.ConnectivityEndpoints.sqlOnDemand  -AccessToken $AccessToken -InputFile $pathToSql -Database $SeverlessDatabaseName -Verbose
    Write-Host "SQL file 'sql/peoplecredential.sql' executed"
}
function AssignSynapseToReaderRoleOfStorageAccount(){
    Write-Host "Getting storage account $global:StorageAccountForCsv"
    $stoAccount=Get-AzResource -ResourceGroupName $global:SynapseResourceGroup -name $global:StorageAccountForCsv
    Write-Host ("The Resource Id of storage account is {0}" -f $stoAccount.ResourceId)

    Write-Host "Getting Managed identity of Synapse"
    
    $synapseResource=Get-AzResource -ResourceGroupName  $global:SynapseResourceGroup -Name $global:SynapseWorkspaceName    
    Write-Host ("Managed identity of Synapse is: {0}" -f $synapseResource.Identity.PrincipalId)
    
    Write-Host "Checking if there any existing role assignments for the Synapse resource on the storage account"
    $existingRoleAssignments=Get-AzRoleAssignment -Scope $stoAccount.ResourceId -ObjectId $synapseResource.Identity.PrincipalId
    if ($null -ne $existingRoleAssignments)
    {
        Write-Host "Deleting all existing role assignments for the storage group"
        az role assignment delete  --assignee $res.Identity.PrincipalId --scope $sto.ResourceId --only-show-errors 1> out-null
        Write-Host "All existing role assignments for the storage group deleted"    
    }
    else {
        Write-Host "No role assginments to delete  for the storage group and synanpse principal id"
    }
    ThrowErrorIfExitCode -message "Failed to delted existing role assignments"

    Write-Host "Adding Synapse to $Global:StorageBlobContributorRole role of Storage account"
    & az role assignment create --assignee $synapseResource.Identity.PrincipalId --role "$Global:StorageBlobContributorRole" --scope $stoAccount.ResourceId
    ThrowErrorIfExitCode -Message "Failed to the managed identity of assign synapase to IAM role of storage account"    
}


Write-Host  "Running in the context of $Ctx"
CreateResourceGroup
CreateStorageAccountForCsv
DeploySynapse
RelaxFireWallRules
CreateServerlessDatabase
CreateMasterKey
CreatePeopleCredential
AssignSynapseToReaderRoleOfStorageAccount
Write-Host "Complete"
Write-Host Get-Date


#you were here, should you write a separate script to upload CSV - which deploys and then uploads
# Purge storage account
# Upload CSV
