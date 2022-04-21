. $PSScriptRoot\common.ps1

$Ctx=Get-AzContext





function CreateResourceGroup {
    Write-Host "Creating resource group $Global:SynapseResourceGroup"
    az group create --name $Global:SynapseResourceGroup --location  $Global:Location --subscription  $Ctx.Subscription.Id  | Out-Null
        
}

Write-Host  "Running in the context of $Ctx"
CreateResourceGroup