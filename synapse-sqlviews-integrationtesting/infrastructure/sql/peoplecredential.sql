
-- CREDENTIALS ARE CONNECTED TO DATASOURCE
/*

IF EXISTS (SELECT * FROM sys.external_data_sources WHERE [name]='peoplesdemo')
BEGIN
    print 'Dropping data source peoplesdemo'
    DROP EXTERNAL DATA SOURCE peoplesdemo
END
*/
GO
IF EXISTS (SELECT * FROM SYS.DATABASE_SCOPED_CREDENTIALS WHERE [name] = 'PEOPLESCREDENTIAL') 
BEGIN
    --DROP DATABASE SCOPED CREDENTIAL PEOPLESCREDENTIAL
    PRINT 'Not dropping the credential because it most likely being used by external tables'
END
ELSE
BEGIN
    CREATE DATABASE SCOPED CREDENTIAL PEOPLESCREDENTIAL  WITH IDENTITY = 'Managed Identity';
    PRINT 'created credential PEOPLESCREDENTIAL'
END
GO


