IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE [name] = 'vwAllCustomers') DROP VIEW vwAllCustomers
GO

CREATE VIEW vwAllCustomers
AS SELECT *
FROM OPENROWSET( 
       PROVIDER='CosmosDB',
       CONNECTION='Account=COSMOSACCOUNTNAMETAG;Database=DATABASENAMETAG',
       OBJECT='customersmaster',
       SERVER_CREDENTIAL='mycosmoscredential')
WITH (  
        ID	varchar(8000) '$.id',
        FirstName   varchar(1000) '$.firstName'
) AS docs
GO
