# Overview
How to maintain a CI/CD structure around SQL Views in a Synapse Serverless Pool

# Talking Points
- Lack of SSDT support
- Python because of data scientists



# References

## Query CSV

- Single file https://docs.microsoft.com/en-us/azure/synapse-analytics/sql/query-single-csv-file
- Multiple file https://docs.microsoft.com/en-us/azure/synapse-analytics/sql/query-folders-multiple-csv-files

This looks good
https://docs.microsoft.com/en-us/azure/synapse-analytics/quickstart-serverless-sql-pool#first-time-setup

## CREATE EXTERNAL DATASOURCE
- [Full documentation](https://docs.microsoft.com/en-us/sql/t-sql/statements/create-external-data-source-transact-sql?view=sql-server-ver16&tabs=dedicated)

## CREATE EXTERNAL TABLE
https://docs.microsoft.com/en-us/azure/synapse-analytics/sql/create-use-external-tables#external-table-on-a-set-of-files

## Query CSV file
https://docs.microsoft.com/en-us/azure/synapse-analytics/sql/query-single-csv-file

## Query Parquet files
https://docs.microsoft.com/en-us/azure/synapse-analytics/sql/query-parquet-files

## Generating a SAS token
https://docs.microsoft.com/en-us/cli/azure/storage/container?view=azure-cli-latest#az-storage-container-generate-sas

## Using managed identity to grant access to storage accounts
https://docs.microsoft.com/en-us/azure/synapse-analytics/sql/develop-storage-files-storage-access-control?tabs=managed-identity



YOU GOT STUFF WORKING
CREAETED A SAS TOKEN

```sql

-- https://csvstoragedemo001.blob.core.windows.net/peoples/peoples.csv
-- https://csvstoragedemo001.blob.core.windows.net/peoples

-- How do you drop the master key

CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'Pass@word123'


IF EXISTS (SELECT * FROM SYS.DATABASE_SCOPED_CREDENTIALS WHERE [name] = 'PEOPLESCREDENTIAL') DROP DATABASE SCOPED CREDENTIAL PEOPLESCREDENTIAL
CREATE DATABASE SCOPED CREDENTIAL PEOPLESCREDENTIAL
WITH 
    IDENTITY = 'SHARED ACCESS SIGNATURE', 
    SECRET = 'sp=r&st=2022-04-26T21:31:27Z&se=2022-06-02T05:31:27Z&spr=https&sv=2020-08-04&sr=c&sig=nR9eVI0N5%2BZL5rL3NJGdreRKTpGrW3DN784zmJYKCz4%3D'
    
    -- sp=r&st=2022-04-26T21:31:27Z&se=2022-06-02T05:31:27Z&spr=https&sv=2020-08-04&sr=c&sig=nR9eVI0N5%2BZL5rL3NJGdreRKTpGrW3DN784zmJYKCz4%3D

DROP EXTERNAL DATA SOURCE peoplesdemo

create external data source peoplesdemo
with ( 
    location = 'https://csvstoragedemo001.blob.core.windows.net/' , 
    CREDENTIAL = PEOPLESCREDENTIAL 
    --TYPE = BLOB_STORAGE
    );


select *
from openrowset(
        bulk 'junk/peoples.csv',
        data_source = 'peoplesdemo',
        format = 'csv',
        parser_version ='2.0'
    ) as rows

```

# Check for the present of a master key
The master key is created on the MASTER database. In production scenarios the symmetric key should be placed in the key vault if not found
```sql

IF NOT EXISTS (SELECT * FROM SYS.KEY_ENCRYPTIONS ke WHERE ke.crypt_type = 'ESKM' )
BEGIN
    PRINT 'No master key found'
    CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'Pass@word123'
END

```

# You were here!!


## Check for presence of external datasource
```sql
IF EXISTS (SELECT * FROM sys.external_data_sources WHERE [name]='peoplesdemo')
BEGIN
    print 'Dropping data source peoplesdemo'
    DROP EXTERNAL DATA SOURCE peoplesdemo
END
```
## Create external datasource
You cannot created a datasource unless you have a credential on the storage account
```sql
create external data source peoplesdemo
with ( 
    location = 'https://csvstoragedemo001.blob.core.windows.net/' , 
    CREDENTIAL = PEOPLESCREDENTIAL 
    --TYPE = BLOB_STORAGE
    );
```

## Create credential using SAS key
You cannot drop a CREDENTIAL if there is an external datasource referencing the credential
```sql
IF EXISTS (SELECT * FROM SYS.DATABASE_SCOPED_CREDENTIALS WHERE [name] = 'PEOPLESCREDENTIAL') DROP DATABASE SCOPED CREDENTIAL PEOPLESCREDENTIAL
CREATE DATABASE SCOPED CREDENTIAL PEOPLESCREDENTIAL
WITH 
    IDENTITY = 'SHARED ACCESS SIGNATURE', 
    SECRET = 'sp=r&st=2022-04-26T21:31:27Z&se=2022-06-02T05:31:27Z&spr=https&sv=2020-08-04&sr=c&sig=nR9eVI0N5%2BZL5rL3NJGdreRKTpGrW3DN784zmJYKCz4%3D'
    
```

# Getting the SQL query to work

## Dropping the data source
```sql
IF EXISTS (SELECT * FROM sys.external_data_sources WHERE [name]='peoplesdemo')
BEGIN
    print 'Dropping data source peoplesdemo'
    DROP EXTERNAL DATA SOURCE peoplesdemo
END

```

## Creating the data source
```sql
create external data source peoplesdemo
with ( 
    -- location = 'https://csvstoragedemo001.blob.core.windows.net/' ,  --did not work
    location = 'https://csvstoragedemo001.blob.core.windows.net/junk' ,
    CREDENTIAL = PEOPLESCREDENTIAL 
    --TYPE = BLOB_STORAGE
    );

```

## Running the query
```sql
select *
from openrowset(
        bulk '/peoples.csv',
        data_source = 'peoplesdemo',
        format = 'csv',
        parser_version ='2.0'
    ) as rows

```

## Creating the external file format
Notice the importance of **FIRST_ROW**. This specifies that the first data row is from row number 2 (1 based)
```sql
IF EXISTS (SELECT * FROM sys.external_file_formats WHERE [name]='CSVFORMAT') 
BEGIN
    DROP EXTERNAL FILE FORMAT CSVFORMAT
    PRINT 'external file format CSVFORMAT was dropped'
END
GO
CREATE EXTERNAL FILE FORMAT CSVFORMAT WITH 
    (  
        FORMAT_TYPE = DELIMITEDTEXT,
        FORMAT_OPTIONS 
            (
                FIRST_ROW=2,
                FIELD_TERMINATOR=',',
                STRING_DELIMITER='"'                
            )
    )
PRINT 'external file format CSVFORMAT was created'

```

## Create the external table
You need the **CSVFORMAT** to have been created using `CREATE EXTERNAL FILE FORMAT`

```sql
IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE [name]='Peoples' AND [TYPE]='U')
BEGIN
    DROP EXTERNAL TABLE Peoples
    PRINT 'Table peoples was dropped'
END
GO
CREATE EXTERNAL TABLE Peoples (
     id int,
     --id nvarchar(20),
     firstname nvarchar(50),
     lastname nvarchar(50),
) WITH (
         LOCATION = '/peoples.csv',
         DATA_SOURCE = peoplesdemo,
         FILE_FORMAT = CSVFORMAT
);
PRINT 'Table peoples was created'
GO
SELECT * FROM Peoples

```
## Getting table schema from INFORMATION_SCHEMA

```sql
SELECT * FROM 
INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='Peoples'
GO
SELECT * FROM 
INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='Peoples' AND COLUMN_NAME='ID'
```

# Lessons learnt
to be consolidated

## Creating the credential
```sql
CREATE DATABASE SCOPED CREDENTIAL PEOPLESCREDENTIAL
WITH IDENTITY = 'Managed Identity';
```

## Creating the external data source
```sql
create external data source peoplesdemo
with ( 
    location = 'https://csvstoragedemo001.blob.core.windows.net/junk', 
    CREDENTIAL = PEOPLESCREDENTIAL 
    )
```

## What is the error message when Synapse does not have permissions?

```
File '/peoples.csv' cannot be opened because it does not exist or it is used by another process.
```


## How to give Synapse permissions to the storage account?
- Use the Synapse system assigned identity. No need to create one. Already there
- Assign this to the Blob contributor role
- Drop and re-create the credential



## How to get the managed identity of an Azure Resource?

```powershell
#Get the resource
$res=Get-AzResource -ResourceGroupName  $global:SynapseResourceGroup -Name $global:SynapseWorkspaceName
$res.Identity.PrincipalId

```

## Creating a file format
```sql

GO
CREATE EXTERNAL FILE FORMAT CSVFORMAT WITH 
    (  
        FORMAT_TYPE = DELIMITEDTEXT,
        FORMAT_OPTIONS 
            (
                FIELD_TERMINATOR=',',
                STRING_DELIMITER='"'                
            )
    )
GO
```
## Create external table
```sql
DROP EXTERNAL TABLE Peoples
GO
CREATE EXTERNAL TABLE Peoples (
     --int,
     id nvarchar(20),
     firstname nvarchar(50),
     lastname nvarchar(50),
) WITH (
         LOCATION = '/peoples.csv',
         DATA_SOURCE = peoplesdemo,
         --FORMAT='csv'
         FILE_FORMAT = CSVFORMAT
);

```
# What was I doing?
- Got the credential working
- Got the data source working
- Got the query to work
- Removed hard coding of storage account in data source
- Create external table is working
- Need to explore int (THI WORKS)
- YOU WERE WORKING ON CSV FILE FORMATS
- CHALLENGE
    - The Credential, Datasource and External table are all dependent. You cannot drop credential wihtout dropping Datasource and you cannot drop Datasource without dropping external table
    - Handle Credential, Datasource and External table in 1 SQL file
    - The single file should be parameterizable
    - what should be the name of the file? PeopleTable.sql
    - We already have the code for merging. See PeopleDataSource.sql
    - What do you parameterize?
    - BLOBENDPOINT
    - CONTAINERNAME
    - TABLENAME
    - Use the TABLENAME to form the credentials and external datasource
    - to keep the script simpler, try not to concatenate, use distinct tags for better readability
    - There is an emerging need for a meta-data table. Prefix with 'system' to avoid conflicts
    - The meta table should have a CSV with info about all other tables
    - Read the meta data table using PowerShell during CI
    - Read the meta data table using DataFrame via external table
- Need to create external data source
- Need to add CREATE TABLE to code
- Need to add DROP TABLE to code
- Need to add CREATE FILE FORMAT to code
- You need to create storage account , create container and upload a sample CSV file
- 
- 

# Structure of a generic table creation SQL

```sql

-- DROP THE EXTERNAL TABLE IF EXISTS
-- DROP DATA SOURCE IF EXISTS
-- DROP CREDENTIAL IF EXISTS

-- CREATE CREDENTIAL
-- CREATE DATA SOURCE
-- CREATE TABLE


--    DROP EXTERNAL TABLE
IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE [name]='{{TABLENAME}}' AND [TYPE]='U')
BEGIN
    DROP EXTERNAL TABLE {{TABLENAME}}
    PRINT 'Table {{TABLENAME}} was dropped'
END
GO

--    DROP EXTERNAL DATA SOURCES
IF EXISTS (SELECT * FROM sys.external_data_sources WHERE [name]='{{DATASOURCENAME}}')
BEGIN
    print 'Dropping data source {{DATASOURCENAME}}'
    DROP EXTERNAL DATA SOURCE {{DATASOURCENAME}}
    print 'Dropped data source {{DATASOURCENAME}}'
END

--    DROP CREDENTIAL - NO NEED TO DROP CREDENTIAL BECAUSE IT IS A MANAGED IDENTITY
GO
IF EXISTS (SELECT * FROM SYS.DATABASE_SCOPED_CREDENTIALS WHERE [name] = '{{CREDENTIALNAME}}') 
BEGIN
    DROP DATABASE SCOPED CREDENTIAL {{CREDENTIALNAME}}
    PRINT 'Dropped the credential {{CREDENTIALNAME}}'
END
GO
---------------------
GO
create external data source {{DATASOURCENAME}}
with ( 
    location = '{{BLOBENDPOINT}}{{CONTAINERNAME}}', 
    CREDENTIAL = PEOPLESCREDENTIAL 
    )
PRINT 'Created external datasource peoplesdemo'

-- CREATE THE EXTERNAL TABLE
``` 

# How do you alter a file format?
I was unable to achieve. See link. It might be possible. The accompanying link from MSFT within this post is broken
https://docs.microsoft.com/en-us/answers/questions/38287/alter-external-file-format-question.html