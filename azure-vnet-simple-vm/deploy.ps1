. $PSScriptRoot\common.ps1



function CreateResourceGroup{
    & az group create --name $Global:ResourceGroup --location $Global:Location --tags $Global:Tags
    ThrowErrorIfExitCode -message "Error while creating resource group $Global:ResourceGroup"    
}


Write-Host "Demo script for testing with Virtual Machines and VNET"
CreateResourceGroup

& $PSScriptRoot\deploy-vnet.ps1
& $PSScriptRoot\deploy-vm.ps1
