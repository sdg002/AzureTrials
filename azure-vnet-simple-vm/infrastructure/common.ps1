. $PSScriptRoot\variables.ps1

Set-StrictMode -Version "Latest"
$ErrorActionPreference="Stop"
Clear-Host


function ThrowErrorIfExitCode($message){
    if ($LASTEXITCODE -eq 0){
        return
    }
    Write-Error -Message $message
}


function GetAcrLogin{
    Write-Host "Begin. Getting all ACR details"
    $acrInfo=az acr show --name $Global:ContainerRegistry --resource-group $Global:ResourceGroup | ConvertFrom-Json -AsHashtable
    $acrLoginServer=$acrInfo["loginServer"]
    Write-Host "Got the ACR login server: $acrLoginServer"
    return $acrLoginServer
}

function GetAcrPassword{
    Write-Host "Getting the ACR password"
    $acrCredentials=(az acr credential show --name $Global:ContainerRegistry --resource-group $Global:ResourceGroup | ConvertFrom-Json -AsHashtable)
    $password=$acrCredentials["passwords"][0]["value"]
    Write-Host "Got the ACR password: $password"
    return $password
}

function GetStorageAccountKey{    
    $keys = & az storage account keys list --account-name $Global:StoAccount --resource-group $Global:ResourceGroup | ConvertFrom-Json -AsHashtable
    return $keys[0]["value"]
}
