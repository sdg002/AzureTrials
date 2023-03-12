$ErrorActionPreference="Stop"

<#
This script relies on the presence of Docker CLI
You will need to change the working directory to the current folder. 
Using absolute path does not work well with "docker build"
#>
$Global:LocalImageName="saudemopythonworker"
# this file should be run in the folder which has a .Dockerfile

$pythonWorkerDirectory= Join-Path -Path $PSScriptRoot -ChildPath ".\..\python-worker-app"
Push-Location -Path $pythonWorkerDirectory
& docker build .\ -t $Global:LocalImageName
Write-Host "Docker build complete"
Pop-Location
