# What is this about?
How to create a Synapse Studio resource using Terraform


# How to run Terraform INIT?
Ensure you have set the subscription correctly using `az account set --subscription <id of the subscription>`
```
terraform init -backend-config="storage_account_name=mydemotfstoragestate" -backend-config="resource_group_name=rg-demo-synapse-using-terraform"
```

# Terraform apply
```
terraform apply -auto-approve
```


# Stuck

## Where were you stuck?

```
Plan: 1 to add, 0 to change, 0 to destroy.
azurerm_storage_data_lake_gen2_filesystem.example: Creating...
╷
│ Error: Error checking for existence of existing File System "example123" (Account "examplestorageac123"): datalakestore.Client#GetProperties: Failure responding to request: StatusCode=403 -- Original Error: autorest/azure: error response cannot be parsed: "" error: EOF
│
│   with azurerm_storage_data_lake_gen2_filesystem.example,
│   on main.tf line 39, in resource "azurerm_storage_data_lake_gen2_filesystem" "example":
│   39: resource "azurerm_storage_data_lake_gen2_filesystem" "example" {

```

## What were you trying?
You were reading here
https://docs.microsoft.com/en-us/azure/storage/blobs/data-lake-storage-directory-file-acl-powershell

