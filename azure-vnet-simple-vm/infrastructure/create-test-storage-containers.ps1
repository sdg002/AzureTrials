. $PSScriptRoot\common.ps1

<#
This script will open up public access so that CLI can create the neccessary containers.
This script WILL NOT disable the public access. Remember to run deploy-storage-account.ps1 to disable public access
#>
function AllowPublicAccess{
    Write-Host "Begin - enabling public access for the storage account $Global:StoAccount"    
    & az storage account update --name $Global:StoAccount --resource-group $Global:ResourceGroup `
        --allow-blob-public-access "true" --default-action "Allow"
    ThrowErrorIfExitCode -message "Error while enabling public access $Global:StoAccount"
    Write-Host "End - enabling public access for the storage account $Global:StoAccount"    
}

function AddSomeContainers{
    Write-Host "Begin - Adding containers to $Global:StoAccount"
    & az storage container create --name "demo1" --resource-group $Global:ResourceGroup --account-name $Global:StoAccount --auth-mode "login"
    ThrowErrorIfExitCode -message "Error while creating container 'demo1'"

    & az storage container create --name "demo2" --resource-group $Global:ResourceGroup --account-name $Global:StoAccount --auth-mode "login"
    ThrowErrorIfExitCode -message "Error while creating container 'demo2'"

    & az storage container create --name "demo3" --resource-group $Global:ResourceGroup --account-name $Global:StoAccount --auth-mode "login"
    ThrowErrorIfExitCode -message "Error while creating container 'demo3'"

    Write-Host "End - Adding containers to $Global:StoAccount"
}

$waitSecondsForPublicAccess=60
AllowPublicAccess
Write-Host "Waiting for $waitSecondsForPublicAccess"
Start-Sleep -Seconds $waitSecondsForPublicAccess
AddSomeContainers
Write-Host "Complete"


