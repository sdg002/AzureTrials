--DROP EXTERNAL TABLE
IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE [name]='People' AND [TYPE]='U')
BEGIN
    DROP EXTERNAL TABLE People
    PRINT 'Table People was dropped'
END
ELSE
BEGIN
    PRINT 'The table People was not found'
END
GO

--    DROP EXTERNAL DATA SOURCES
IF EXISTS (SELECT * FROM sys.external_data_sources WHERE [name]='PeopleDatasource')
BEGIN
    print 'Dropping data source PeopleDatasource'
    DROP EXTERNAL DATA SOURCE PeopleDatasource
    print 'Dropped data source PeopleDatasource'
END
ELSE
BEGIN
    PRINT 'The datasource PeopleDatasource was not found'
END
GO
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


-- CREATE EXTERNAL TABLE People (
--      id int,
--      firstname nvarchar(50),
--      lastname nvarchar(50),
-- ) WITH (
--          LOCATION = '/people.csv',
--          DATA_SOURCE = {{DATASOURCENAME}},
--          FILE_FORMAT = CSVFORMAT
-- );
-- GO
-- PRINT 'Created table People'