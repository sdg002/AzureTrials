. $PSScriptRoot\..\common\variables.ps1


$armFilePath="$PSScriptRoot/arm.json"
Write-Host "Going to deploy ARM template"

az deployment group create --resource-group $Global:ResourceGroup --template-file $armFilePath  --verbose
RaiseCliError -message "Failed to deploy ARM template $armFilePath"
