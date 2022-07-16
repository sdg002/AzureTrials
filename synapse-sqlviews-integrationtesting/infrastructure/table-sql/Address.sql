--DROP EXTERNAL TABLE
IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE [name]='Address' AND [TYPE]='U')
BEGIN
    DROP EXTERNAL TABLE Address
    PRINT 'Table Address was dropped'
END
ELSE
BEGIN
    PRINT 'The table Address was not found'
END
GO

--    DROP EXTERNAL DATA SOURCES
IF EXISTS (SELECT * FROM sys.external_data_sources WHERE [name]='AddressDatasource')
BEGIN
    print 'Dropping data source ADDRESSDATASOURCE'
    DROP EXTERNAL DATA SOURCE ADDRESSDATASOURCE
    print 'Dropped data source ADDRESSDATASOURCE'
END
ELSE
BEGIN
    PRINT 'The datasource AddressDatasource was not found'
END
GO
CREATE EXTERNAL DATA SOURCE ADDRESSDATASOURCE
WITH ( 
    LOCATION = '{{BLOBENDPOINT}}address', 
    CREDENTIAL = MYCREDENTIAL 
    )

PRINT 'Created external datasource ADDRESSDATASOURCE'
GO

PRINT 'Creating table Address'
GO
CREATE EXTERNAL TABLE Address (
     personid INT,
     city nvarchar(50),
     [state] nvarchar(50),
     postcode nvarchar(50),
     [country] nvarchar(50)
) WITH (
         LOCATION = '/address.csv',
         DATA_SOURCE = ADDRESSDATASOURCE,
         FILE_FORMAT = CSVFORMAT
);
GO
PRINT 'Created table Address'
