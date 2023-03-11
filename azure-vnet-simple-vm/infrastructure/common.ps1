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

