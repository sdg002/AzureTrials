

```
    Not able to print the following
    $databases=Invoke-Sqlcmd -ServerInstance $workspace.ConnectivityEndpoints.sqlOnDemand  -AccessToken $access_token -Query "SELECT name FROM SYS.DATABASES" -Database "MASTER"
    Write-Output $databases

```