# Overview
How to create an instance of Azure Analysis Service via PowerShell and ARM

#Progress so far
You were able to connect via Power BI
You were able to connect via DAX Studio
Use the server asazure://uksouth.asazure.windows.net/demosaas001
You used saurabh_dasgupta@hotmail.com and head injury
database adventureworks


# Next steps
- How do you create a blank database?
- Check how much was the billing when you kept it shut  (0.22 was the accumulated costs as of 8am , Jan 7)
- Create a new model using Visual Studio

# References
## Sql Server Analysis tutorial
https://docs.microsoft.com/en-us/analysis-services/tutorial-tabular-1400/as-lesson-1-create-a-new-tabular-model-project?view=asallproducts-allversions

## PowerShell cmdlet reference for Sql Server Analysis Server
https://docs.microsoft.com/en-us/powershell/module/az.analysisservices/test-azanalysisservicesserver?view=azps-7.1.0

## C# deply a new database by using the Tabular Object Model
https://docs.microsoft.com/en-us/analysis-services/tom/create-and-deploy-an-empty-database-analysis-services-amo-tom?view=asallproducts-allversions

## Good article on C#, using tokens (from a service running with managed identity)
https://endjin.com/blog/2020/02/azure-analysis-services-how-to-open-a-connection-from-net

## REST API for refreshing SSAS
https://docs.microsoft.com/en-us/azure/analysis-services/analysis-services-async-refresh

## How to restore World Wide Importers database into Azure Sql Instance
https://docs.microsoft.com/en-us/azure/azure-sql/managed-instance/restore-sample-database-quickstart

## Source for World Wide Importers datbase
https://docs.microsoft.com/en-us/sql/samples/wide-world-importers-oltp-install-configure?view=sql-server-ver15
https://github.com/Microsoft/sql-server-samples/releases/tag/wide-world-importers-v1.0

## How to script the creation of a Managed Sql server instance
https://adamtheautomator.com/create-azure-sql-database/#Creating_the_Azure_SQL_Server
https://docs.microsoft.com/en-us/powershell/module/az.sql/new-azsqlserver?view=azps-7.1.0#examples

# Lessons
You cannot restore .bak file into Azure database
https://stackoverflow.com/questions/66723032/azure-data-studio-why-is-restore-option-missing-entirely


# How to restore a bacpac file?
- Download the .bacpac file of World Wide Importers
- Create a storage account. Create a container in this account.
- Upload .bacpac file to this storage account
- Launch SSMS (You got to be careful about the version, 18.x worked for me, 17.x stalled at MFA)
- Connect to the Azure Sql Server (Copy server name from overview page)
- Right click on *Databases* and select *????* option
- This will prompt you for the location of the .bacpac file. Specify the storage account and the container name.
- Import will begin
- Wait..

# Sql server service models
https://docs.microsoft.com/en-us/azure/azure-sql/database/service-tiers-dtu#single-database-dtu-and-storage-limits
This is the single point of documentation for DTU pricing models

# Querying Sql server
## Querying with Azure login
```
Invoke-Sqlcmd -ServerInstance $s.FullyQualifiedDomainName -Database $SqlDatabase.DatabaseName -Query "Select * from sys.tables" -AccessToken $token
```
## Querying with username and password
```
Invoke-Sqlcmd -ServerInstance $s.FullyQualifiedDomainName -Database $SqlDatabase.DatabaseName -Query "Select * from sys.tables" -Password $SqlPassword -Username $SqlUsername
```
