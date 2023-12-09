Set-StrictMode -Version "latest"
$environment=$env:Environment
$Global:FirstFunctionApp="func-demoservice1-$environment-uks-001"
Write-Host "Going to deploy Azure function $Global:FirstFunctionApp"
func azure functionapp publish $Global:FirstFunctionApp --python