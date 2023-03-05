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

You 
- Created the vm
- this has a public ip
- this is on the virtual network
- wrote a script to stop-de-allocate the vm

Next steps
- Create a storage account
- Add it to the vnet
- Disable public access
- Try connecting to this storage account from outside
- Try connecting to this storage account from inside
- 
- 