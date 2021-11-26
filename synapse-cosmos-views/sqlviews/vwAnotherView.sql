IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE [name] = 'vwAnotherView') DROP VIEW vwAnotherView
GO

CREATE VIEW vwAnotherView
AS SELECT *
FROM OPENROWSET( 
       PROVIDER='CosmosDB',
       CONNECTION='Account=COSMOSACCOUNTNAMETAG;Database=DATABASENAMETAG',
       OBJECT='customers',
       SERVER_CREDENTIAL='mycosmoscredential')
WITH (  
        FirstName   varchar(1000) '$.firstName',
        ID	varchar(8000) '$.id'
) AS docs
GO
