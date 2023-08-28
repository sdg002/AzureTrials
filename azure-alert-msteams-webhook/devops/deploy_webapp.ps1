<#
to be done
#>

$pathToCsharp=Join-Path -Path $PSScriptRoot -ChildPath "../csharp-webapp/csharp-webapp/csharp-webapp.csproj"
$pathToCsharpPublish=Join-Path -Path $env:TEMP -ChildPath csharp-demo-webapp
$pathToZip = Join-Path -Path $PSScriptRoot -ChildPath "webapp.zip"
if (Test-Path -Path $pathToCsharpPublish)
{
    Write-Host "Deleting the publish location $pathToCsharpPublish"
    Remove-Item -Path $pathToCsharpPublish -Force -Recurse
}
$pathToCsharp
Test-Path $pathToCsharp

Write-Host "Begin-Going to build and publish the CSPROJ $pathToCsharp"
dotnet publish $pathToCsharp --output $pathToCsharpPublish --configuration Release
Write-Host "End-Going to build and publish the CSPROJ $pathToCsharp"

Write-Host "Begin-The ZIP will be created in the folder $pathToZip"
Push-Location -Path $pathToCsharpPublish
Compress-Archive *.*  -DestinationPath  $pathToZip -Force
Pop-Location
Write-Host "End-The ZIP was created in the folder $pathToZip"


