CREATE EXTERNAL TABLE Address (
     personid INT,
     city nvarchar(50),
     [state] nvarchar(50),
     postcode nvarchar(50),
     [country] nvarchar(50)
) WITH (
         LOCATION = '/addresses.csv',
         DATA_SOURCE = AddressDatasource,
         --FORMAT='csv'
         FILE_FORMAT = CSVFORMAT
);
