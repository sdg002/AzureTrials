. $PSScriptRoot\common.ps1



function CreateResourceGroup{
    & az group create --name $Global:ResourceGroup --location $Global:Location --tags $Global:Tags
    ThrowErrorIfExitCode -message "Error while creating resource group $Global:ResourceGroup"    
}


Write-Host "Demo script for testing with Virtual Machines and VNET"
CreateResourceGroup

& $PSScriptRoot\deploy-vnet.ps1
& $PSScriptRoot\deploy-vm.ps1
& $PSScriptRoot\deploy-storage-account.ps1
& $PSScriptRoot\deploy-acr.ps1
# TODO Bring createimaeg.ps1 to the top level and include this call here
& $PSScriptRoot\push-image.ps1
& $PSScriptRoot\deploy-container-instance.ps1


