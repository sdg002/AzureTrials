# About
this was an approach where we took the automation to another level by using a meta-data file to
- Create a container in the storage account
- Creat the exeternal data source which points to this container
- Create the external table

# Accompanying files
## storagemetadata.csv
This is the meta-data file which contains the list of containers and the SQL Table names

# CreateStorageContainer.ps1
Will read the meta-data file and create all the containers

# Deploy.ps1
Will read the meta-data file and create the external data source and external tables