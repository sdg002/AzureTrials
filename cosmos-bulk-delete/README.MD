# Overview
Demonstrates how to use *ComosDB* PowerShell module for bulk CRUD operations on Cosmos

![Cosmos](images/azure.png)

# How to install the Powershell module?
```
Install-Module -Scope CurrentUser -Name CosmosDB
```

Sample JSON
```
{
    "id": "1001",
    "firstName": "John1001",
    "lastName": "Doe1001"
}

```

# Accompanying scripts
- CreateCosmos.ps1
- DeleteAllRecords.ps1
- PopulateCollection.ps1

# Essential parameters in Common.ps1
Remember to change the following to suit your environment
```powershell
Set-StrictMode -Version "2.0"
$ErrorActionPreference="Stop"
$Global:CosmosResourceGroup="rg-demo-cosmos-serverless"
$Global:CosmosAccountName="saudemocosmosserverless"
$Global:CustomersManagementDatabase="CustomerManagement"
$Global:CustomersMasterContainer="customers"
$Global:Location="uksouth"

```

# How to run the accompanying PowerShell scripts?
- Clone this repository
- Navigate to the folder which contains this README.MD file
- Launch PowerShell Core
- Ensure you have the core modules installed 
- Change the variables in *Common.ps1* to point to your Cosmos account

## Create the database
- Create a Cosmos account by runnning the script **CreateCosmos.ps1**
- Create a database and a collection (refer variables in Commons.ps1)

## Populate the container with JSON
Run **PopulateCollection.ps**. You should now see 2 documents created

## Purge all documents in the container
Run **DeleteAllRecords.ps1**

# PowerShell modules neccessary
- Az.Accounts
- Az.Resources
- Az.CosmosDb
- CosmosDb