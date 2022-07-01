CREATE EXTERNAL TABLE Peoples (
     id int,
     firstname nvarchar(50),
     lastname nvarchar(50),
) WITH (
         LOCATION = '/peoples.csv',
         DATA_SOURCE = {{DATASOURCENAME}},
         FILE_FORMAT = CSVFORMAT
);
GO
PRINT 'Created table Peoples'