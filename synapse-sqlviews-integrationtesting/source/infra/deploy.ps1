. $PSScriptRoot\common.ps1

Clear-Host
$Ctx=Get-AzContext
$FireWallRuleName="AllowAllAccess"
$AccessToken = (Get-AzAccessToken -ResourceUrl https://database.windows.net).Token
$SeverlessDatabaseName="myserverlessdb"
$synapsePassWord="Pass@word123"



function DeploySynapse{
    $stoAccountForSynapse="synasepstorage{0}" -f $env:environment
    Write-Host "Creating storage account for Synapse $stoAccountForSynapse"
    & az storage account create --name $stoAccountForSynapse --resource-group $Global:SynapseResourceGroup --location $Global:Location --sku "Standard_LRS" --subscription $Ctx.Subscription.Id | Out-Null
    ThrowErrorIfExitCode -Message "Could not create storage account $stoAccountForSynapse"

    Write-Host "Creating Synapse workspace"
    & az synapse workspace create --name $Global:SynapseWorkspaceName --location $Global:Location --storage-account $stoAccountForSynapse --sql-admin-login-user $Global:SynapseAdminUser --sql-admin-login-password $synapsePassWord --file-system $Global:SynapseFileShare --subscription $Ctx.Subscription.Id --resource-group $Global:SynapseResourceGroup
    ThrowErrorIfExitCode -Message "Could not create synapse workspace  $Global:SynapseWorkspaceName"

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
    $pathToSql=Join-Path -Path $PSScriptRoot -ChildPath "..\common-sql\new-serverless-database.sql"
    Write-Host "Going to execute SQL file '$pathToSql' to create new database"
    Invoke-Sqlcmd -ServerInstance $workspace.ConnectivityEndpoints.sqlOnDemand  -AccessToken $AccessToken -InputFile $pathToSql -Database "MASTER" -Verbose
    Write-Host "SQL file executed. New database created"
}

function CreateMasterKey(){
    #This is a 1 time step for every SQL Server - you need this for creating a credential - but do we need it if we are using managed identity
    Write-Host "Going to run SQL script to create master key"
    $workspace=Get-AzSynapseWorkspace -ResourceGroupName $Global:SynapseResourceGroup -Name $Global:SynapseWorkspaceName
    $pathToSql=Join-Path -Path $PSScriptRoot -ChildPath "../common-sql/createmasterkey.sql"
    Write-Host "Going to execute SQL file '$pathToSql' to create new database"
    Invoke-Sqlcmd -ServerInstance $workspace.ConnectivityEndpoints.sqlOnDemand  -AccessToken $AccessToken -InputFile $pathToSql -Database $SeverlessDatabaseName -Verbose
    Write-Host "SQL file executed. New database created"
}

function CreateManagedIdentityCredential(){
    Write-Host "Going to run SQL script to create credential"
    $workspace=Get-AzSynapseWorkspace -ResourceGroupName $Global:SynapseResourceGroup -Name $Global:SynapseWorkspaceName
    $pathToSql=Join-Path -Path $PSScriptRoot -ChildPath "../common-sql/managed-identity-credential.sql"
    Invoke-Sqlcmd -ServerInstance $workspace.ConnectivityEndpoints.sqlOnDemand  -AccessToken $AccessToken -InputFile $pathToSql -Database $SeverlessDatabaseName -Verbose
    Write-Host "SQL file 'sql/managed-identity-credential.sql' executed"
}

function CreatePeopleDataSource(){
    $stoAccount=Get-AzStorageAccount -ResourceGroupName $global:SynapseResourceGroup -name $global:StorageAccountForCsv

    $pathToSql=Join-Path -Path $PSScriptRoot -ChildPath "../common-sql/peopledatasource.sql"
    $dict=@{}
    $dict.Add("{{BLOBENDPOINT}}",$stoAccount.PrimaryEndpoints.Blob)
    $dict.Add("{{CONTAINERNAME}}","junk")

    Write-Host "Replacing tags in file: $pathToSql"
    $sqlWithReplacements=ReplaceTextInFile -sqlfilename $pathToSql -tagvalues $dict

    Write-Host "Going to run SQL script to create people data source"
    $workspace=Get-AzSynapseWorkspace -ResourceGroupName $Global:SynapseResourceGroup -Name $Global:SynapseWorkspaceName
    Invoke-Sqlcmd -ServerInstance $workspace.ConnectivityEndpoints.sqlOnDemand  -AccessToken $AccessToken -Query $sqlWithReplacements -Database $SeverlessDatabaseName -Verbose
    Write-Host "SQL file 'sql/peopledatasource.sql' executed"
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
        az role assignment delete  --assignee $synapseResource.Identity.PrincipalId --scope $stoAccount.ResourceId --only-show-errors --subscription  $Ctx.Subscription.Id
        Write-Host "All existing role assignments for the storage group deleted"    
    }
    else {
        Write-Host "No role assginments to delete  for the storage group and synanpse principal id"
    }
    ThrowErrorIfExitCode -message "Failed to delted existing role assignments"

    Write-Host "Adding Synapse to $Global:StorageBlobContributorRole role of Storage account"
    & az role assignment create --assignee $synapseResource.Identity.PrincipalId --role "$Global:StorageBlobContributorRole" --scope $stoAccount.ResourceId --subscription  $Ctx.Subscription.Id
    ThrowErrorIfExitCode -Message "Failed to the managed identity of assign synapase to IAM role of storage account"    
}

function CreateFileFormat{
    $file="../common-sql/createfileformats.sql"
    Write-Host "Going to run the SQL file {$file} "

    #you were here, write the SQL
    $workspace=Get-AzSynapseWorkspace -ResourceGroupName $Global:SynapseResourceGroup -Name $Global:SynapseWorkspaceName
    $pathToSql=Join-Path -Path $PSScriptRoot -ChildPath $file
    Invoke-Sqlcmd -ServerInstance $workspace.ConnectivityEndpoints.sqlOnDemand  -AccessToken $AccessToken -InputFile $pathToSql -Database $SeverlessDatabaseName -Verbose
    Write-Host "SQL file '$file' executed"

}

function CreateStorageAccountForCsv{
    Write-Host "Creating storage account $Global:StorageAccountForCsv"
    az storage account create --name $Global:StorageAccountForCsv --resource-group $Global:SynapseResourceGroup --location $Global:Location --sku "Standard_LRS" --subscription $Ctx.Subscription.Id  | Out-Null
    ThrowErrorIfExitCode -Message "Could not create storage account $Global:StorageAccountForCsv"
}

function CreateStorageAccount {
    param ([string]$container)
    Write-Host "Creating Azure storage account container $container"
    & az storage container create --name $container --account-name $Global:StorageAccountForCsv    
    Write-Host "Created Azure storage account container $container"
}

function DropExternalTable {
    param (
        [string]$table
    )
    $workspace=Get-AzSynapseWorkspace -ResourceGroupName $Global:SynapseResourceGroup -Name $Global:SynapseWorkspaceName
    $dropTableSql="IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE [name]='$table' AND [TYPE]='U') DROP EXTERNAL TABLE $table"
    Write-Host "Dropping external table $table"
    Invoke-Sqlcmd -ServerInstance $workspace.ConnectivityEndpoints.sqlOnDemand  -AccessToken $AccessToken -Query $dropTableSql -Database $SeverlessDatabaseName -Verbose
    Write-Host "Dropped external table $table"
    
}

function DropExternalDataSource {
    param (
        [string]$datasource
    )
    $workspace=Get-AzSynapseWorkspace -ResourceGroupName $Global:SynapseResourceGroup -Name $Global:SynapseWorkspaceName
    $dropDataSourceSql="IF EXISTS (SELECT * FROM sys.external_data_sources WHERE [name]='$datasource') DROP EXTERNAL DATA SOURCE $datasource"
    Write-Host "Dropping external data source $datasource"
    Invoke-Sqlcmd -ServerInstance $workspace.ConnectivityEndpoints.sqlOnDemand  -AccessToken $AccessToken -Query $dropDataSourceSql -Database $SeverlessDatabaseName -Verbose    
    Write-Host "Dropped external data source $datasource"
}

function CreateExternalTable {
    param (
        [string]$filename
    )
    Write-Host "Creating external table from file: $filename"
    $stoAccount=Get-AzStorageAccount -ResourceGroupName $global:SynapseResourceGroup -name $global:StorageAccountForCsv
    Write-Host ("The storage account endpoint will be used {0}" -f $stoAccount.PrimaryEndpoints.Blob)
    $dict=@{}
    $dict.Add("{{BLOBENDPOINT}}",$stoAccount.PrimaryEndpoints.Blob)

    $pathToSql=Join-Path -Path $PSScriptRoot -ChildPath "../table-sql/$filename"
    Write-Host "Replacing tags in file: $pathToSql"
    $sqlWithReplacements=ReplaceTextInFile -sqlfilename $pathToSql -tagvalues $dict

    Write-Host "Going to run SQL script to create objects neccessary for external table $filename"
    $workspace=Get-AzSynapseWorkspace -ResourceGroupName $Global:SynapseResourceGroup -Name $Global:SynapseWorkspaceName
    Invoke-Sqlcmd -ServerInstance $workspace.ConnectivityEndpoints.sqlOnDemand  -AccessToken $AccessToken -Query $sqlWithReplacements -Database $SeverlessDatabaseName -Verbose
    Write-Host "SQL file '$pathToSql' executed"    

}

Write-Host  "Running in the context of:"
$Ctx
CreateResourceGroup
DeploySynapse
RelaxFireWallRules
CreateServerlessDatabase
CreateMasterKey
CreateManagedIdentityCredential
CreateStorageAccountForCsv
AssignSynapseToReaderRoleOfStorageAccount
CreateFileFormat

CreateStorageAccount -container "people"
CreateStorageAccount -container "address"

#
#People objects
#
DropExternalTable -table "People"
DropExternalDataSource -datasource "PEOPLEDATASOURCE"
CreateExternalTable -filename "People.sql"
#
#Address objects
#
DropExternalTable -table "Address"
DropExternalDataSource -datasource "ADDRESSDATASOURCE"
CreateExternalTable -filename "Address.sql"

Write-Host "Complete"
Write-Host Get-Date

