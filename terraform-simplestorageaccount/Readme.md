# Overview
This is a demonstration of how to create a simple storage account using Terraform
The main objective is to find out a way to keep the Terraform storage container configurable

# Setting the environment variables for TF INIT
You will need to set the access key
```
set ARM_ACCESS_KEY=********
```
Followed by `init` command
```
terraform init
```

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
