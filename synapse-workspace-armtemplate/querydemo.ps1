
$ErrorActionPreference="Stop"
Set-StrictMode -Version "latest"
Clear-Host

$server="armsynapse001fromwrkstn-ondemand.sql.azuresynapse.net"
$database="master"
$adminuser="johndoe"
$adminpassword=Read-Host -Prompt "Specify Admin password"

Invoke-Sqlcmd -ServerInstance $server -Database $database -Query "SELECT GETDATE()" -Username $adminuser -Password $adminpassword
