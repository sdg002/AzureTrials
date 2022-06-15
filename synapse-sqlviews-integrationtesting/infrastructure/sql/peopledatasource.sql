IF EXISTS (SELECT * FROM sys.external_data_sources WHERE [name]='peoplesdemo')
BEGIN
    print 'Dropping data source peoplesdemo'
    DROP EXTERNAL DATA SOURCE peoplesdemo
    print 'Dropped data source peoplesdemo'
END

GO
create external data source peoplesdemo
with ( 
    location = '{{BLOBENDPOINT}}{{CONTAINERNAME}}', 
    CREDENTIAL = PEOPLESCREDENTIAL 
    )
PRINT 'Created external datasource peoplesdemo'