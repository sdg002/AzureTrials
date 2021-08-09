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
