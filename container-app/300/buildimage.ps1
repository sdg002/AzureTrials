. $PSScriptRoot/commonvariables.ps1

$CurDir = $PSScriptRoot
$DockerDir = Join-Path -Path $CurDir -ChildPath "../sample-job-app"
$DockerDir = (Resolve-Path -Path $DockerDir).Path
Write-Host "Docker dir is $DockerDir"


Write-Host "Going to docker build the image to local tag $Global:LocalImageName"
Push-Location -Path $DockerDir
docker build .\ -t $Global:LocalImageName
Pop-Location
RaiseCliError -message "Failed to docker build local image $Global:LocalImageName"


