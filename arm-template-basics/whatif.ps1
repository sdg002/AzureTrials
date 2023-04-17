Set-StrictMode -Version "latest"
$ErrorActionPreference="Stop"



$subFolder=".\1-arm-object-output"
$armFileName="$subFolder\arm.json"
$armFilePath = Join-path -Path $PSScriptRoot -ChildPath $armFileName
$outputFile=Join-path -Path "$PSScriptRoot\$subFolder" -ChildPath  "arm.output.json"


$ResourceGroup="rg-demo-vm-vnet-experiment"

az deployment group create --resource-group $ResourceGroup --template-file $armFilePath  --verbose > $outputFile
#tried --what-if , did not work
