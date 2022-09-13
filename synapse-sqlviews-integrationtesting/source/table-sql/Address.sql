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
