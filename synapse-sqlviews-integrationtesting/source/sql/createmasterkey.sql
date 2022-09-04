
IF EXISTS (SELECT * FROM SYS.KEY_ENCRYPTIONS ke WHERE ke.crypt_type = 'ESKM' )
BEGIN
    PRINT 'There is already a master key'
    -- USE MASTER
    -- DROP MASTER KEY
    --  Changed database context to 'master'. Cannot drop master key because certificate '##MS_InstanceCertificate##' is encrypted by it.

END
ELSE
BEGIN
    PRINT 'No master key found'
    CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'Pass@word123'
    PRINT 'Created master key found'
END
