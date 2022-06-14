IF EXISTS (SELECT * FROM sys.external_data_sources WHERE [name]='peoplesdemo')
BEGIN
    print 'Dropping data source peoplesdemo'
    DROP EXTERNAL DATA SOURCE peoplesdemo
END
GO
IF EXISTS (SELECT * FROM SYS.DATABASE_SCOPED_CREDENTIALS WHERE [name] = 'PEOPLESCREDENTIAL') 
BEGIN
    DROP DATABASE SCOPED CREDENTIAL PEOPLESCREDENTIAL
    PRINT 'Dropped the credential'
END
GO

