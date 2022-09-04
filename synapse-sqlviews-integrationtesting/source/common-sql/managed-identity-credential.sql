
-- CREDENTIALS ARE CONNECTED TO DATASOURCE
/*

IF EXISTS (SELECT * FROM sys.external_data_sources WHERE [name]='peoplesdemo')
BEGIN
    print 'Dropping data source peoplesdemo'
    DROP EXTERNAL DATA SOURCE peoplesdemo
END
*/
GO
IF EXISTS (SELECT * FROM SYS.DATABASE_SCOPED_CREDENTIALS WHERE [name] = 'MYCREDENTIAL') 
BEGIN
    PRINT 'Not attempting to drop the credential MYCREDENTIAL because it most likely being used by external tables'
END
ELSE
BEGIN
    CREATE DATABASE SCOPED CREDENTIAL MYCREDENTIAL  WITH IDENTITY = 'Managed Identity';
    PRINT 'created credential MYCREDENTIAL'
END
GO


