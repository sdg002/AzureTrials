Set-StrictMode -Version "latest"
$ErrorActionPreference="Stop"
$ResourceGroup="rg-demo-vm-vnet-experiment"


function ExecuteSimpleArmTemplateOutput($folder,$armFileName){
    $armFilePath = Join-path -Path $PSScriptRoot -ChildPath "$folder\$armFileName"
    $outputFile=Join-path -Path "$PSScriptRoot\$folder" -ChildPath  "arm.output.json"
    az deployment group create --resource-group $ResourceGroup --template-file $armFilePath  --verbose > $outputFile
    Write-Host "The output was written to file file $outputFile"
}

ExecuteSimpleArmTemplateOutput -folder ".\1-arm-object-output" -armFileName "arm.json"
ExecuteSimpleArmTemplateOutput -folder ".\2-arm-string-int-output" -armFileName "arm.json"

# $subFolder=".\1-arm-object-output"
# $armFileName="$subFolder\arm.json"





#tried --what-if , did not work
