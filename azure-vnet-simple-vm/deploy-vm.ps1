. $PSScriptRoot\common.ps1


function CreatePublicIpAddress{

    Write-Host "Begin.Creating public ip address $Global:PublicIp1"
    & az network public-ip create `
    --resource-group $Global:ResourceGroup `
    --name $Global:PublicIp1 `
    --version IPv4 `
    --sku Standard `
    --zone 1 2 3    
    ThrowErrorIfExitCode -message "Could not create public ip address $Global:PublicIp1"
    Write-Host "End.Creating public ip address $Global:PublicIp1"
}

function DeployVirtualMachine($name){
    Write-Host "Begin.VM deployment begin"
    ThrowErrorIfExitCode -message "Error while creating VM $name"
    & az vm create --resource-group $Global:ResourceGroup --image $Global:VirtualMachineImage `
    --admin-username $Global:VirtualMachineAdminUser `
    --admin-password $Global:VirtualMachineAdminPassword `
    --vnet-name $Global:Vnet `
    --subnet "default" `
    --public-ip-address $Global:PublicIp1 `
    --name $name

    ThrowErrorIfExitCode -message "Could not create virtual machine $name"
    Write-Host "End.VM deployment begin"
}

CreatePublicIpAddress
DeployVirtualMachine -name $Global:VirtualMachineName1
