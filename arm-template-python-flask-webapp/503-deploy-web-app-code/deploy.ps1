. $PSScriptRoot/variables.ps1





Write-Host "Going to deploy upload Python code to the web app $Global:WebAppName"
$SourceCodeLocaiton = Join-Path -Path $PSScriptRoot -ChildPath "..\400-create-hello-world-flask-app-manually"
Write-Host "The Python code will be deployed from the location $SourceCodeLocaiton"
Push-Location -Path $SourceCodeLocaiton
az webapp up --name $Global:WebAppName
Pop-Location

RaiseCliError -message "Failed to deploy storage account"
