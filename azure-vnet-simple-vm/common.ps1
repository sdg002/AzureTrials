Set-StrictMode -Version "Latest"
$ErrorActionPreference="Stop"
Clear-Host


$Global:Location="uksouth"
$Global:ResourceGroup="rg-demo-vm-vnet-experiment"
$Global:Tags=" department=hysterionics owner=james@bond"
$Global:Vnet="myVnet"

function ThrowErrorIfExitCode($message){
    if ($LASTEXITCODE -eq 0){
        return
    }
    Write-Error -Message $message
}

