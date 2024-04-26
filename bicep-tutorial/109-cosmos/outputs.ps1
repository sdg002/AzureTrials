. $PSScriptRoot/../common.ps1
. $PSScriptRoot/variables.ps1


& az deployment group create --resource-group $Global:ResourceGroup `
    --template-file "$PSScriptRoot\templates\outputs.bicep" `
    --parameters `
    myparam="value for my param" `
    cosmosaccount=$Global:CosmosAccount `
    --verbose
