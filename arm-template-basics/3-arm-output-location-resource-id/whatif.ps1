Set-StrictMode -Version "latest"
$ErrorActionPreference="Stop"
$ResourceGroup="rg-demo-vm-vnet-experiment"

$outputFile=Join-path -Path $PSScriptRoot -ChildPath  "arm.output.json"
$armFilePath = Join-path -Path $PSScriptRoot -ChildPath "arm.json"
az deployment group create --resource-group $ResourceGroup --template-file $armFilePath  --verbose 
