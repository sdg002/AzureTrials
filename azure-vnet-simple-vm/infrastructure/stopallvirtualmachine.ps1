. $PSScriptRoot\common.ps1



$listOfVms = (& az vm list --resource-group $Global:ResourceGroup) | ConvertFrom-Json -AsHashTable

foreach($vm in $listOfVms)
{
    Write-Host ("Shutting down VM {0}" -f $vm["name"])
    & az vm stop --resource-group $Global:ResourceGroup --name $vm["name"] --verbose
    & az vm deallocate --resource-group $Global:ResourceGroup --name $vm["name"] --verbose
}


