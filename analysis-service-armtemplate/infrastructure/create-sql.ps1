. $PSScriptRoot\common.ps1
Set-StrictMode -Version "latest"
Clear-Host
$ErrorActionPreference="Stop"

# Convert to SecureString
[securestring]$secStringPassword = ConvertTo-SecureString $SqlPassword -AsPlainText -Force
[pscredential]$credObject = New-Object System.Management.Automation.PSCredential ($SqlUsername, $secStringPassword)
$SqlServer=$null
$SqlDatabase=$null

function CreateSqlServer()
{
    
    $Global:SqlServer=Get-AzSqlServer -ResourceGroupName $ResourceGroup -ServerName $SqlServerName -ErrorAction Continue
    if ($null -eq $Global:SqlServer){
        Write-Host "No sql server with the name $SqlServerName found in resource group $ResourceGroup"
        Write-Host "Going to create new instance of SqlServer"
        $Global:SqlServer=New-AzSqlServer -ResourceGroupName $ResourceGroup -ServerName $SqlServerName -Location $Location  -SqlAdministratorCredentials $credObject 
        Write-Host "Created Sql server"
        }
    else {
        Write-Host "Sql server already exists in resource group"
    }   
}

function  SetSqlAdminPassword {
    Write-Host "Resetting administrator password"
    Set-AzSqlServer -ResourceGroupName $ResourceGroup -ServerName $SqlServerName -SqlAdministratorPassword $secStringPassword        
}

function  CreateSqlDatabase {
    Write-Host "Checking for presence of database $DatabaseName on server $SqlServerName"
    $Global:SqlDatabase=Get-AzSqlDatabase -ResourceGroupName $ResourceGroup -ServerName $SqlServerName -DatabaseName $DatabaseName -ErrorAction Continue
    if ($null -eq $Global:SqlDatabase){
        Write-Host "Database $DatabaseName on server $SqlServerName not found, going to create"
        #S0 for Standard workloads
        #Basic for Basic workload
        #https://docs.microsoft.com/en-us/azure/azure-sql/database/service-tiers-dtu#single-database-dtu-and-storage-limits
        $Global:SqlDatabase=New-AzSqlDatabase -ResourceGroupName $ResourceGroup -ServerName $SqlServerName -DatabaseName $DatabaseName -RequestedServiceObjectiveName "Basic"
        Write-Host "Database created"
    }
    else {
        Write-Host "The database '$DatabaseName' already exists on server $SqlServerName"
    }    
}

function  AllowIPAccess {
    $existingRules = Get-AzSqlServerFirewallRule -ResourceGroupName $ResourceGroup -ServerName $SqlServerName
    foreach ($rule in $existingRules) {
        Remove-AzSqlServerFirewallRule -ResourceGroupName $ResourceGroup -ServerName $SqlServerName -FirewallRuleName $rule.FirewallRuleName
        Write-Host ("Deleted existing firewall rule '{0}'" -f $rule.FirewallRuleName)
    }
    $ip = Invoke-RestMethod "http://ipinfo.io/json" | Select-Object -ExpandProperty IP
    New-AzSqlServerFirewallRule -ServerName $SqlServerName -ResourceGroupName $ResourceGroup -FirewallRuleName "Allow access to local IP" -StartIpAddress $ip -EndIpAddress $ip
}
function  TestDatabase {
    Invoke-Sqlcmd -ServerInstance $Global:SqlDatabase.FullyQualifiedDomainName -Database master -Query "Select name  from sys.databases" -Password $SqlPassword -Username $SqlUsername
    Invoke-Sqlcmd -ServerInstance $Global:SqlDatabase.FullyQualifiedDomainName -Database $Global:SqlDatabase.DatabaseName -Query "Select Getutcdate()" -Password $SqlPassword -Username $SqlUsername    
}
New-AzResourceGroup -Name $ResourceGroup -Force -Location $Location | Out-Null
"Resource group $ResourceGroup created or already exists"

CreateSqlServer
CreateSqlDatabase
AllowIPAccess
$SqlServer



Write-Host ("Sql server full qualified naem is '{0}'" -f $Global:SqlServer.FullyQualifiedDomainName)
Write-Host ("Database DTU model is '{0}'" -f $Global:SqlDatabase.RequestedServiceObjectiveName)



#Query something


<#
https://docs.microsoft.com/en-us/powershell/module/az.sql/new-azsqlserver?view=azps-7.1.0#examples
ExternalAdminSID
Specifies the object ID of the user, group or application which is the Azure Active Directory administrator.



IdentityType
Type of identity to be assigned to the server. Possible values are SystemAsssigned, UserAssigned, 'SystemAssigned,UserAssigned' and None

-EnableActiveDirectoryOnlyAuthentication
You need to upgrade the SQL cdmlet 

Set-AzSqlServer

Set-AzSqlServerActiveDirectoryAdministrator
https://docs.microsoft.com/en-us/powershell/module/az.sql/set-azsqlserveractivedirectoryadministrator?view=azps-7.1.0


Enable-AzSqlServerActiveDirectoryOnlyAuthentication
https://docs.microsoft.com/en-us/powershell/module/az.sql/enable-azsqlserveractivedirectoryonlyauthentication?view=azps-7.1.0#examples


Next steps
----------
    Use AD group for SqlAdmin
    You will have to create the group and add current user

    Create storage account
    Create container
    Download BACPAC file and upload to container
    Create credential

#>