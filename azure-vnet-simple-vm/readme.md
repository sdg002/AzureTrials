[[_TOC_]]

# Objective
I am trying to experiement with creation of **virtual network** and placing a Virtual Machine on that VNET

# References
## Create a virtual network using Azure CLI
https://learn.microsoft.com/en-us/azure/virtual-network/quick-create-cli#create-virtual-machines

## Getting a list of VM images
```
az vm image list --architecture x64 --location uksouth > .\out\images.json
```

## Getting all supported sizes
```
az vm list-sizes --location $Global:Location  > .\out\vm-sizes.json
```

## Getting all SKUs of a VM

```
az vm list-skus --location uksouth > .\out\vm-skus.json
```

## Difference between stop and deallocate
https://learn.microsoft.com/en-us/answers/questions/574969/whats-the-difference-between-deallocated-and-stopp

## Disallowing public access to a storage account

See the `--public-network-access Disabled` argument in the `az storage account create` command line

https://learn.microsoft.com/en-us/cli/azure/storage/account?view=azure-cli-latest#az-storage-account-create

## Azure Blob client examples for Python
https://learn.microsoft.com/en-us/python/api/overview/azure/storage-blob-readme?view=azure-python#examples

## Setting secret environment variables
https://learn.microsoft.com/en-us/azure/container-instances/container-instances-environment-variables

## Azure Container groups and VNET
https://learn.microsoft.com/en-us/azure/container-instances/container-instances-vnet

## What is subnet delegation ?
https://learn.microsoft.com/en-us/azure/virtual-network/subnet-delegation-overview


## Add or remove subnet delegation ?
https://learn.microsoft.com/en-us/azure/virtual-network/manage-subnet-delegation?tabs=manage-subnet-delegation-portal

To place a Container group in an existing subnet, the subnet should be empty of all other resources
```
or use an existing subnet emptied of all other resources and configuration
```

## Challenges with subnet delegation and Java container instances
https://github.com/Azure/azure-libraries-for-java/issues/741
(is this relevant?)


## Vnet and subnet address ranges - you cannot overlap addresses !
Read this example:
https://learn.microsoft.com/en-us/answers/questions/50693/how-to-define-address-range-(cidr)-for-azure-subne

You have an overall IP range for the vnet. Each of the subnets must have an IP range which does not overlap with any of the subnets

---



# Fixing PowerShell and VS Code
- I had PWSH installed as a local admin(C:/Program files/PowerShell/)
- I uninstalled and installed the zip to a user level folder
- This caused a problem with VS Code Terminal window

# Step 1 - Let VS Code know the new path of PowerShell Core
- 
![vscode-powershell.png](docs/images/vscode-powershell.png)

# Step 2 - Re-install PowerShell extensions
- You need this extension for debugging PowerShell scripts
- Uninstall and re-install the extension
- Re-start VS Code


![vscode-powershell-extension-launch-settings.png](docs/images/vscode-powershell-extension-launch-settings.png)


# Where was I ?
- Guidance on VM and VNET
- https://learn.microsoft.com/en-us/azure/virtual-network/quick-create-powershell

## What was done
- Create a storage account (done)
- Add to vnet
- You are able to select a VNET
- Disable public access (You want to Enabled from selected virtual networks and IP addresses)
- Create a storage container
- Try connecting to this storage account from outside
- Try connecting to this storage account from inside
- Install Azure CLI on the VM
- Write some script that uploads/downloads data to a storage container
- Test the access of the storage account from the VM (use the test scritp)

## Next steps
- Create with AD access only
- Ask question on Reddit - How to access storage account Find out how to grant access to the storage account from Azure IP addresses (Probably there is nothing at all)
- Write some Python code which can access the storage container
- Test locally as docker image
- Add a Container instance
- Deploy Container to Azure
- Fetch logs
- Add to vnet
- Test with and without VNET


---


# Testing the access to Azure Storage

## Objective
We want to verify that the Network restrictions are indeed working. We will use the accompanying script `test-storage-account.ps1` . 

## Setting the acount key on PowerShell Console
 1. Before executing this script you will need to head over to Azure Portal and grab the Storage Account key
 1. Launch a new Powershell Core console
 1. Navigate to the folder where this repo has been cloned
 1. Launch a PowerShell Console and type the following command
 
```powershell
$env:AZURE_STORAGE_kEY=Get-Clipboard
```
![portal-grab-storage-account-key.png
](docs/images/portal-grab-storage-account-key.png)

![pwsh-setting-storage-key-env-variable.png
](docs/images/pwsh-setting-storage-key-env-variable.png)

## Running the test script
![pwsh-running-test-storage-account.png
](docs/images/pwsh-running-test-storage-account.png)

## With network restrictions in place
![az-storage-container-list-blocked.png
](docs/images/az-storage-container-list-blocked.png)

## Without any network restrictions
If you allow Public access and run again

![az-storage-container-list-enabled-all-access.png
](docs/images/az-storage-container-list-enabled-all-access.png)


---

# Testing the access from Container instance



## When container is not on the VNET

### Public access on storage account is turned off
We can see that the the Azure container instance failed to access the storage account
![container-logs-auth-failed.png](docs/images/container-logs-auth-failed.png)

### Public access on storage account is turned on
We can see that the the Azure container instance was able to access the storage account
![container-logs-auth-succeeded-not-on-vnet.png](docs/images/container-logs-auth-succeeded-not-on-vnet.png)

---

# IP address before and after VNET

## Before VNET

![container-logs-ipaddress-before-vnet.png](docs/images/container-logs-ipaddress-before-vnet.png)

## After VNET

![container-logs-auth-succeeded-after-vnet.png](docs/images/container-logs-auth-succeeded-after-vnet.png)


---

# Secret environment variable

## How it appears on the logs (annotate the variable in the picture) ?

![container-logs-secret-environment-variable.png](docs/images/container-logs-secret-environment-variable.png)


## How it appears on Container properties of the Azure portal ?

![container-properties-secret-environment-variable.png](docs/images/container-properties-secret-environment-variable.png)



---

# Lessons learnt

## Azure CLI will not let you access a storage account with network rules in place
I was under the assumption that **Azure CLI** will let me do everything that **Azure Portal** lets me do. When Public network access is blocked, Azure Portal still allows me to see the Blobs. But the Azure CLI does not permit this.
https://github.com/Azure/azure-cli/issues/18415

## What are the work arounds ?
1. Enable Public Access, wait for 60 seconds and do all operations.
1. Use a hosted Devops agent which is on the same vnet
1. 

---

# Installing Docker extensions in VS Code
Installing the Docker extension in VS Code will simplify Docker management. 

## Which Docker extension to install ?
![docker-which-extension.png](docs/images/docker-which-extension.png)

## How to run Docker build on a Dockler ?
![docker-build.png](docs/images/docker-build.png)

## How to run a Docker image ?
![docker-run-image.png](docs/images/docker-run-image.png)

---

# Docker and Azure Devops
## MS documentation page
https://learn.microsoft.com/en-us/azure/devops/pipelines/ecosystems/containers/acr-template?view=azure-devops

## Sample YAML

```YAML
- stage: Build
  displayName: Build and push stage
  jobs:  
  - job: Build
    displayName: Build job
    pool:
      vmImage: $(vmImageName)
    steps:
    - task: Docker@2
      displayName: Build and push an image to container registry
      inputs:
        command: buildAndPush
        repository: $(imageRepository)
        dockerfile: $(dockerfilePath)
        containerRegistry: $(dockerRegistryServiceConnection)
        tags: |
          $(tag)
```

## MS Link on Docker Devops Tasks
### Docker Build and Push (any Docker command)
This needs a service connection
https://learn.microsoft.com/en-us/azure/devops/pipelines/tasks/reference/docker-v2?view=azure-pipelines&tabs=classic

### Docker CLI installation
https://learn.microsoft.com/en-us/azure/devops/pipelines/tasks/reference/docker-installer-v0?view=azure-pipelines

```yml
# Docker CLI installer v0
# Install Docker CLI on agent machine.
- task: DockerInstaller@0
  inputs:
    dockerVersion: '17.09.0-ce' # string. Required. Docker Version. Default: 17.09.0-ce.
    #releaseType: 'stable' # 'stable' | 'edge' | 'test' | 'nightly'. Release type. Default: stable.
```


---