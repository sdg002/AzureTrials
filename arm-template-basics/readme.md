[[_TOC_]]

# About this article
I have presented a simple step by step hands on guide to understand Azure ARM templates. There is a widely held belief that Azure ARM templates are terribly complicated and thus there is a need for 3rd party solutions. It my humble hope that at the end of this hands on guide I will be able to convince you otherwise

---

# Prerequisites
- VS Code with ARM extensions installed
- PowerShell Core
- Azure CLI installed and signed in
- An Azure subscription

![vscode_arm_template_extension.png](docs/images/vscode_arm_template_extension.png)

---

# Structure of this Guide
to be done
[???talk about the folder structure, prep folder, how to run each of the scripts]


---

# Step 0 - Prepping the resource group

We will need a resource group to contain all the Azure resources we create. For this guide we will confine oursleves to a one and only resource group. 

## Creating a basic resource group using the Azure CLI
This is one of the simplest CLI commands
```powershell
& az group create --location $Global:Location --name $Global:ResourceGroup
```

## Creating a resource group using the Azure CLI with tags

Having tags is essential in an enterprise environment. This facilicates the central IT to get a birds eye view  of the dozens/hundreds of applications
```powershell
& az group create --location $Global:Location --name $Global:ResourceGroup --tags department=finance owner=johndoe@cool.com costcenter=eusales
```

![resource-group-tags.png](docs/images/resource-group-tags.png)

---
