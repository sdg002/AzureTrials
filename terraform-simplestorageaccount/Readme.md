# Overview
This is a demonstration of how to create a simple storage account using Terraform
The main objective is to find out a way to keep the Terraform storage container configurable

# Setting the environment variables for TF INIT
## Option 1 - You could hard code in the main.tf
Good for a quick test. This cannot take us far. For obvious reasons, this is to be avoided.

## Option 3 - Use the environment variable  ARM_ACCESS_KEY
You will need to set the access key using the following environment variable
```
set ARM_ACCESS_KEY=********
```
Followed by `init` command
```
terraform init
```

## Option 4 - Use the backend-config option in init

```
terraform init -backend-config="storage_account_name=anotherstorage0123"
```
Once done, then the current folder remembers this value and `plan` and `apply` commands can work as usual


## Option 2 - Rely on the context provided by AZ command line
- Terraform will use the information provided by `az account show` to determine the subscription and then acquire the key to the storage account.
- You do not need to use any environment variable
- Just ensure you have done `az account set -s <your subscription id>`


# How to define variables?
Create another file `variables.tf`
Add the following to this file
```
variable "location" {
  type = string
}
```

# How to set variable values?
```
set TF_VAR_location=uksouth
set TF_VAR_demoresourcegroup=myresourcegroup
```

```
set TF_VAR_demoresourcegroup=rg-myresourcegroup
```
Refer this link from Hashicorp https://www.terraform.io/docs/cli/config/environment-variables.html

```
terraform apply -auto-approve
```


# How does Terraform get to know about your Azure details?
Terraform appears to be relying on the current Azure context that was set by the `AZ` command line

## Do this test?
- Launch a new CMD prompt
- Ensure none of the TERRAFORM variables like `ARM_KEY` exist in this console.
- Run `terraform init` and `terraform plan`
- Terraform will still work
- Now change the current Azure subscription by `az account set <some other subscription>`
- Try `terraform init`.
- Terraform will complain about not being able to find the storage state

# Azure Reference
## How to see all your subscriptions?
```
az account list
```

## How to set the current subscription?
```
az account set -s <ID OF THE SUBSCRIPTION>
```

# Terraform challenges
You cannot use variables to externalize the name of the storage account used to store the state

See issue here https://github.com/hashicorp/terraform/issues/13022
