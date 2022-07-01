PRINT  'Going to create external SQL objects neccessary for an external table {{TABLENAME}}'


--DROP EXTERNAL TABLE
IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE [name]='{{TABLENAME}}' AND [TYPE]='U')
BEGIN
    DROP EXTERNAL TABLE {{TABLENAME}}
    PRINT 'Table {{TABLENAME}} was dropped'
END
ELSE
BEGIN
    PRINT 'The table {{TABLENAME}} was not found'
END
GO

--    DROP EXTERNAL DATA SOURCES
IF EXISTS (SELECT * FROM sys.external_data_sources WHERE [name]='{{DATASOURCENAME}}')
BEGIN
    print 'Dropping data source {{DATASOURCENAME}}'
    DROP EXTERNAL DATA SOURCE {{DATASOURCENAME}}
    print 'Dropped data source {{DATASOURCENAME}}'
END
ELSE
BEGIN
    PRINT 'The datasource {{DATASOURCENAME}} was not found'
END
GO
CREATE EXTERNAL DATA SOURCE {{DATASOURCENAME}}
WITH ( 
    LOCATION = '{{BLOBENDPOINT}}{{CONTAINERNAME}}', 
    CREDENTIAL = {{CREDENTIALNAME}} 
    )

PRINT 'Created external datasource {{DATASOURCENAME}}'
GO
