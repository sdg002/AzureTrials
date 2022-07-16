CREATE EXTERNAL DATA SOURCE PEOPLEDATASOURCE
WITH ( 
    LOCATION = '{{BLOBENDPOINT}}people', 
    CREDENTIAL = MYCREDENTIAL 
    )

PRINT 'Created external datasource PEOPLEDATASOURCE'
GO

PRINT 'Creating table People'
GO
CREATE EXTERNAL TABLE People (
     id int,
     firstname nvarchar(50),
     lastname nvarchar(50),
) WITH (
         LOCATION = '/people.csv',
         DATA_SOURCE = PEOPLEDATASOURCE,
         FILE_FORMAT = CSVFORMAT
);
GO
PRINT 'Created table People'

