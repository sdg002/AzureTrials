Set-StrictMode -Version "Latest"
Clear-Host
$ErrorActionPreference="Stop"
Write-Host "This script will delete all resource groups in all subscriptions which contain the pattern 'junk' OR 'demo'"
$prompt=Read-Host "Do you want to proceed?  Press CTRL+C to quit. Press 'y' to proceed"
if ($prompt -ne "y")
{
    Write-Host "Quitting"
    return
}

$patterns=@("junk","demo")
$subs=Get-AzSubscription
$countOfGroupsDeleted=0
foreach ($sub in $subs) {
    Write-Host ("Finding all resource groups in the subscription '{0}'" -f $sub.Name)
    Set-AzContext -Subscription $sub.Name
    $groups=Get-AzResourceGroup
    foreach ($group in $groups) {
        Write-Host ("`t{0}" -f $group.ResourceGroupName)
        foreach ($pattern in $patterns) {
            $wildcard="*{0}*" -f  $pattern   
            if ($group.ResourceGroupName -like $wildcard)
            {
                Remove-AzResourceGroup -Name $group.ResourceGroupName -Force
                $countOfGroupsDeleted
            }
        }                
    }
    Write-Host "--------------------------------------"
}
Write-Host ("Count of groups deleted {0}" -f $countOfGroupsDeleted)


