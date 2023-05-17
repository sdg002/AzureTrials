. $PSScriptRoot/variables.ps1





Write-Host "Going to deploy upload Python code to the web app $Global:WebAppName"
Push-Location -Path "C:\Users\saurabhd\MyTrials\AzureStuff\AzureTrials\AzureTrials\arm-template-python-flask-webapp\400-create-hello-world-flask-app-manually"
az webapp up --name $Global:WebAppName
Pop-Location

RaiseCliError -message "Failed to deploy storage account"
