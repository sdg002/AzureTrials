Set-StrictMode -Version "Latest"
$ErrorActionPreference="Stop"
Clear-Host


$Global:Location="uksouth"
$Global:ResourceGroup="rg-demo-vm-vnet-experiment"
$Global:Tags=" department=hysterionics owner=james@bond"
$Global:Vnet="myVnet"
$Global:VirtualMachineName1="myvm001"
$Global:VirtualMachineImage="Win2022Datacenter"
$Global:VirtualMachineSize="D2s_v3"
$Global:VirtualMachineAdminUser="saurabhd"
$Global:VirtualMachineAdminPassword="Pass@word123"
$Global:PublicIp1="myPublicIP1"

function ThrowErrorIfExitCode($message){
    if ($LASTEXITCODE -eq 0){
        return
    }
    Write-Error -Message $message
}

