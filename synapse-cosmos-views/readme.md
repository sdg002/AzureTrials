# Overview
In this article we demonstrate the basics of the following:
- How to deploy SQL views to an existing instance of **Azure Synapse Studio**.
- This article assumes the presence of a **Azure Synapse Studio** instance (give link to ARM template deployment)

# MS links
- [How to write a SQL query inside Synapse Worksapce](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql/query-cosmos-db-analytical-store?tabs=openrowset-key)
- PowerShell Cosmos reference (to be done)


# Sample JSON

## Sample 1
```
{
    "firstName": "john",
    "id": "1001",
}
```

## Sample 2
```
{
    "firstName": "jane",
    "id": "1002",
}

```

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

# Next steps
Write a Powershell script to 
- provide a sample JSON file(s) , no need to 
https://docs.microsoft.com/en-us/powershell/module/az.cosmosdb/new-azcosmosdbsqldatabase?view=azps-6.6.0
https://docs.microsoft.com/en-us/powershell/module/az.cosmosdb/new-azcosmosdbsqlcontainer?view=azps-6.6.0



