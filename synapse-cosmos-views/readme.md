# Overview
In this article we demonstrate the basics of the following:
- How to deploy SQL views to an existing instance of **Azure Synapse Studio**.
- This article assumes the presence of a **Azure Synapse Studio** instance. Refer PowerShell scripts in the sibling folder [synapse-workspace-armtemplate](../synapse-workspace-armtemplate) to deploy a new instance.
- This article focusses more on the CI/CD aspects of the deploying SQL views to the serverlss instance of Azure Synapse Studio

# Prerequisites
- A functioning Azure Cloud subscription with full rights
- You will need to create a provisioned instance of Cosmos with Analytical store. This is most likely going to cost you money (PS script provided).
- Windows 10, PowerShell Core. (Not tested on Mac OS , but as per MS, PowerShell core should work)
- Visual Studio Code

# Quick start
- Deploy an instance of the Azure Synapse using the script available under the folder '**synapse-workspace-armtemplate**'
- Get inside this new Synapse Workspace instance and manually create an instance of a serverless database by the name **myserverlessdb**. The SQL views will be created in this serverless database.

-![Deploy Synapse Workspace using ARM template](images/create-serverless-database.png)
- Deploy an instance of Cosmos using the script `createcosmos.ps1`. A new Cosmos account will be created with Analytical Storage enabled.
- The script will also create a new database and a container with the names **customers** and **customermaster** respectively
- Use the Azure Portal to load the Cosmos container with JSON documents from the `samplejson` folder
- ![Create a new document in Cosmos](images/cosmos_add_new_customer.png)
- Execute the script `installviews.ps` to deploy the SQL views
- Follow the steps under **How to test the Sql Views** to execute the SQL views and examine the results

# How to test the Sql Views?
**to be done, show how to use Invoke-SqlCmd ,or just give a snippet that you have used inside the PowerShell**

# MS links
- [How to write a SQL query inside Synapse Worksapce](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql/query-cosmos-db-analytical-store?tabs=openrowset-key)
- PowerShell Cosmos reference **to be done**


# Sample query 1

```
SELECT TOP 10 *
FROM OPENROWSET( 
       'CosmosDB',
       'Account=democosmosquery123;Database=sampledatabase;Key=0q76IU4Bd2b1RVjyx1N2PRWhqqNPDI7KxustUWs93lx3QN9BaJNoL3zAzDNwK37CTqvQ6CN9xBZpZsE7obA5JA==',
       customers)
WITH (  
        id	varchar(8000),
        firstName   varchar(1000)
) AS docs

```

# Sample query 2 - with renamed columns
```
SELECT TOP 10 *
FROM OPENROWSET( 
       'CosmosDB',
       'Account=democosmosquery123;Database=sampledatabase;Key=0q76IU4Bd2b1RVjyx1N2PRWhqqNPDI7KxustUWs93lx3QN9BaJNoL3zAzDNwK37CTqvQ6CN9xBZpZsE7obA5JA==',
       customers)
WITH (  
        ID	varchar(8000) '$.id',
        FirstName   varchar(1000) '$.firstName'
) AS docs

```

# SQL to create credential
In the following example, the `SECRET` is the Cosmos account key.
```
CREATE CREDENTIAL MyCosmosDbAccountCredential
WITH IDENTITY = 'SHARED ACCESS SIGNATURE', SECRET = '0q76IU4Bd2b1RVjyx1N2PRWhqqNPDI7KxustUWs93lx3QN9BaJNoL3zAzDNwK37CTqvQ6CN9xBZpZsE7obA5JA==';
```

Achieving the same more defensively

```
IF EXISTS (SELECT * FROM SYS.CREDENTIALS WHERE [name] = 'MyCosmosDbAccountCredential') DROP CREDENTIAL MyCosmosDbAccountCredential
CREATE CREDENTIAL MyCosmosDbAccountCredential
WITH IDENTITY = 'SHARED ACCESS SIGNATURE', SECRET = '0q76IU4Bd2b1RVjyx1N2PRWhqqNPDI7KxustUWs93lx3QN9BaJNoL3zAzDNwK37CTqvQ6CN9xBZpZsE7obA5JA==';
```

# Querying Cosmos by specifying a Credential

```
SELECT TOP 10 *
FROM OPENROWSET( 
       PROVIDER='CosmosDB',
       CONNECTION='Account=democosmosquery123;Database=sampledatabase',
       OBJECT='customers',
       SERVER_CREDENTIAL='MyCosmosDbAccountCredential')
WITH (  
        ID	varchar(8000) '$.id',
        FirstName   varchar(1000) '$.firstName'
) AS docs

```

# Creating a custom SQL View
```
IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE [name] = 'vwCustomers') DROP VIEW vwCustomers
GO

CREATE VIEW vwCustomers 
AS SELECT *
FROM OPENROWSET( 
       PROVIDER='CosmosDB',
       CONNECTION='Account=democosmosquery123;Database=sampledatabase',
       OBJECT='customers',
       SERVER_CREDENTIAL='MyCosmosDbAccountCredential')
WITH (  
        ID	varchar(8000) '$.id',
        FirstName   varchar(1000) '$.firstName'
) AS docs
GO

```
# Script to create a sample Cosmos database
The accompanying script `createcosmos.p1` will do the following:
- Create a new Cosmos account by the name `mydemo001account`
- Create a new Cosmos database in this account by the name `customers`
- Create a new container `customersmaster` in the database `customers`


