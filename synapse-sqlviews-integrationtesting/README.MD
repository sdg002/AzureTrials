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

## Query Parquet files
https://docs.microsoft.com/en-us/azure/synapse-analytics/sql/query-parquet-files





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