. $PSScriptRoot/common.ps1



$Global:ResourceGroup

$resources=(az resource list --resource-group $Global:ResourceGroup | ConvertFrom-Json -AsHashTable)

if ($null -eq $resources)
{
    Write-Host "No resources found"
    exit
}
Write-host ("Found {0} resources" -f $resources.Count)



function DeleteResources()
{
    $count_deleted=0
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
