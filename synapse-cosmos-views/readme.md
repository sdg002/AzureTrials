# Overview

# MS links
https://docs.microsoft.com/en-us/azure/synapse-analytics/sql/query-cosmos-db-analytical-store?tabs=openrowset-key


# Sample JSON
```
{
    "firstName": "john",
    "id": "1001",
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
