SELECT name from SYS.DATABASES
IF NOT EXISTS (SELECT * FROM SYS.DATABASES WHERE [name]='myserverlessdb')
BEGIN
    print 'db was not found'
    CREATE DATABASE myserverlessdb
    PRINT 'new database created'
END

/*
A more robust approach would have been to DROP the database always and freshly create a new one
However, we encounter the following error. The usual approach of making it single user and then dropping does not work for Synapse
    --DROP DATABASE myserverlessdb 
    --Cannot drop database "myserverlessdb" because it is currently in use.   Msg 3702, Level 16, State 4, Procedure , Line 5.
*/