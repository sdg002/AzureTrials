param ([Parameter(Mandatory)][string]$ResourceGroup)
#TODO warn the user that this will delete, 
#TODO Comments in this script
#TODO Show the current subscription details before you warn the user




function DeleteResources()
{
    $count_deleted=0
    $resources=(az resource list --resource-group $ResourceGroup | ConvertFrom-Json -AsHashTable)

    if ($null -eq $resources)
    {
        Write-Host "No resources found"
        return $count_deleted
    }
    Write-host ("Found {0} resources" -f $resources.Count)
    
    foreach($resource in $resources) 
    { 
    
        try {
            $id=$resource["id"] 
            Write-Host "Going to delete resource with id: $id"
            & az resource delete --ids $id --verbose
            $count_deleted+=1
        }
        catch {
            Write-Host $_
        }
    }
    return $count_deleted
}

while ($true) 
{
    $deleted=DeleteResources
    if (0 -eq $deleted)
    {
        Write-Host "No more resources to delete"
        break;
    }
    Write-Host "No of resources deleted=$deleted Going to try again"
}
