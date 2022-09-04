
/*
Create the CSV format
Do not try to drop because it is being referenced by other external tables
Have a mini-create statement and then follow it up with an alter statement
*/

PRINT 'Attempting to create external file format CSVFORMAT'
IF EXISTS (SELECT * FROM sys.external_file_formats WHERE [name]='CSVFORMAT') 
BEGIN
    PRINT 'Not creating external file format CSVFORMAT because it already exists'
END
ELSE
BEGIN
CREATE EXTERNAL FILE FORMAT CSVFORMAT WITH 
    (  
        FORMAT_TYPE = DELIMITEDTEXT,
        FORMAT_OPTIONS 
            (
                FIRST_ROW=2,
                FIELD_TERMINATOR=',',
                STRING_DELIMITER='"'                
            )
    )
PRINT 'Created external file format CSVFORMAT'
END
