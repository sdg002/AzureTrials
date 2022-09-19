. $PSScriptRoot\common.ps1


function CreateResourceGroup {
    Write-Host "Creating resource group $Global:ResourceGroup"
    az group create --name $Global:ResourceGroup --location  $Global:Location  | Out-Null
    ThrowErrorIfExitCode -Message "Could not create resource group $Global:ResourceGroup"
}


CreateResourceGroup
