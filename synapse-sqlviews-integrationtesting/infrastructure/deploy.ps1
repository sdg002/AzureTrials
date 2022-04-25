. $PSScriptRoot\common.ps1

$Ctx=Get-AzContext





function CreateResourceGroup {
    Write-Host "Creating resource group $Global:SynapseResourceGroup"
    az group create --name $Global:SynapseResourceGroup --location  $Global:Location --subscription  $Ctx.Subscription.Id  | Out-Null
    ThrowErrorIfExitCode -Message "Could not create resource group $Global:SynapseResourceGroup"
}

function CreateStorageAccountForCsv{
    Write-Host "Creating storage account $Global:StorageAccountForCsv"
    az storage account create --name $Global:StorageAccountForCsv --resource-group $Global:SynapseResourceGroup --location $Global:Location --sku "Standard_LRS" --subscription $Ctx.Subscription.Id | Out-Null
    ThrowErrorIfExitCode -Message "Could not create storage account $Global:StorageAccountForCsv"
}

function DeploySynapse{
    $stoAccountForSynapse="synasepstorage{0}" -f $env:environment
    $synapsePassWord="Pass@word123"
    Write-Host "Creating storage account for Synapse $stoAccountForSynapse"
    & az storage account create --name $stoAccountForSynapse --resource-group $Global:SynapseResourceGroup --location $Global:Location --sku "Standard_LRS" --subscription $Ctx.Subscription.Id | Out-Null
    ThrowErrorIfExitCode -Message "Could not create storage account $stoAccountForSynapse"
    Write-Host "Creating Synapse workspace"
    & az synapse workspace create --name $Global:SynapseWorkspaceName --location $Global:Location --storage-account $stoAccountForSynapse --sql-admin-login-user $Global:SynapseAdminUser --sql-admin-login-password $synapsePassWord --file-system $Global:SynapseFileShare --subscription $Ctx.Subscription.Id --resource-group $Global:SynapseResourceGroup
    ThrowErrorIfExitCode -Message "Could not create synapse workspace  $Global:SynapseWorkspaceName"

}

function ThrowErrorIfExitCode($message){
    if (0 -eq $LASTEXITCODE){
        return
    }
    Write-Error -Message $message
}

Write-Host  "Running in the context of $Ctx"
CreateResourceGroup
CreateStorageAccountForCsv
DeploySynapse
Write-Host "Complete"
# you were here, deploy the synapse
# Is there a CLI? If not use PowerShell
# Get storage account path
# Purge storage account
# Upload CSV
