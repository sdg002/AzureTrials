


# Automating via Azure Devops
## You will need to create an App registration
Azure portal --> Active Directory --> App registration

Once you have create a new App registration, you should now see a new service principal
```
Get-AzADServicePrincipal -DisplayName "Name of your app registrion"
```
The `ApplicationId` property should match the Client ID property on the Azure portal

## The service principal should have permissions on the Subscription
- Launch Azure Portal
- Select the Subscription
- Select "Access control(IAM)"
- Select "Role Assignments"
- Role = "owner"
- ASsign access to = User,Group or service principal
- ASsign access to = <name of the service principal>
- Click save

## Create a Client secret
- Click on Certificates and Secrets
- Create a new secret.
- Copy the Secret to a safe location (We will need this in Devops)

## Create a service connection in Azure Devops
- Click on Azure Devops
- Select your project
- Select the Gear icon on the bottom left panel
 -Select 'Service Connections

 ## Additional permissions on Azure Active Directory
 - Simply having 'Owner' permissions on the Azure Subscription is not enough
 - This gets tricky. 
 - You will need to enter the "App Registration" page , select "API permissions" and then grant additional permissions
 - Follow this article from Terraform https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/guides/service_principal_configuration


# Challenges with Azure Active Directory permissions
## Problem
Azure Devops is not happy with the permissions while attempting to `Get-AzADGroup` 
## Solution
The Devops account should be added to the AD permissions group 'User Administrator'
Azure portal --> Azure AD --> Roled and administrators --> Select "User Administrator" --> Add the Devops account

## How to troubleshoot Devops account permissions issues?
You will need to emulate Azure login as a service principal. This is the service principal which is running Azure Devops.

```
	$secret="THE SECRET FROM THE CERTIFICATES AND SECRETS BLADE OF APP REGISTRATION PAGE OF THE ACCOUNT WHICH IS BEING USED FOR DEVOPS"
    $appId="The value of the Application(Client ID) ID on the App registration page"
    $tenant="The value of the Directory(tenant) ID on the App registration page"
	$sec=ConvertTo-SecureString  $secret -AsPlainText
	$cred=New-Object  pscredential($appId,$sec)
    Connect-AzAccount -ServicePrincipal -Credential $cred -Tenant $tenant
    Get-AzContext
    #You should see the service principal as the logged in user
    #Any operation from now will be emulating this service principal account
```


# Appendix
Azure Devops needs the Az.Synapse module. You should add a PowerShell Task at the very start and issue the following command
```
Install-Module -Name Az.Synapse -Scope CurrentUser -Force
```

# Microsoft docs
https://docs.microsoft.com/en-us/azure/azure-sql/database/authentication-aad-configure?tabs=azure-powershell


# How to query SQL via PowerShell?
```
    $ResourceGroup="rg-demo-junk-synapse-1"
    $SynapseWorkspaceName="demo12346"
    $workspace=Get-AzSynapseWorkspace -Name  $SynapseWorkspaceName -ResourceGroupName $ResourceGroup
    $SynapseWorkspaceName="demo12346"

    $t=(Get-AzAccessToken -ResourceUrl https://database.windows.net)    
    $databases=Invoke-Sqlcmd -ServerInstance $workspace.ConnectivityEndpoints.sqlOnDemand  -AccessToken $t.Token -Query "SELECT name FROM SYS.DATABASES" -Database "MASTER"
    Write-Output $databases

```


# Adding a Service principal to a specific database

Manually get inside the Azure Synapse workspace and add the service principal to the specific database
```
CREATE USER [Demo devops 002] FROM EXTERNAL PROVIDER
ALTER ROLE db_owner ADD MEMBER [Demo devops 002]  --sp_addrolemember is not supported
```

# Creating a simple View
```
CREATE VIEW vwPortal1 AS
SELECT GETDATE() as MyDate
```

Now, you should be able to run any query againt this database while impersonating a service principal
```
Invoke-Sqlcmd -AccessToken $t.Token -ServerInstance $workspace.ConnectivityEndpoints.sqlOnDemand -Database "junk" -Query "SELECT GETDATE()"
Invoke-Sqlcmd -AccessToken $t.Token -ServerInstance $workspace.ConnectivityEndpoints.sqlOnDemand -Database "junk" -Query "SELECT * FROM vwPortal1"
Invoke-Sqlcmd -AccessToken $t.Token -ServerInstance $workspace.ConnectivityEndpoints.sqlOnDemand -Database "junk" -InputFile .\DemoView.sql

```


# Trying to add a System identity to the SQL instance behind Azure Synapse
I was following this article https://docs.microsoft.com/en-us/azure/azure-sql/database/authentication-aad-service-principal-tutorial#assign-an-identity-to-the-azure-sql-logical-server

if you try the following command:
```
Get-AzSqlServer
```
You should see the hidden SQL Instances that were created as a result of Synapse creation


I tried assigning a System identity but was denied because of Deny Role Assignments (which can be viewed on the hidden resource group)
```
Set-AzSqlServer -ResourceGroupName synapseworkspace-managedrg-37d28572-93fd-4b5a-8868-6ac3e07ef5c5 -ServerName demo12346 -AssignIdentity
```

# Where was I ?
- Problem with system identity and SQL access remains
- Tried adding the current service principal to AD group using AddCurrentUserToADGroup