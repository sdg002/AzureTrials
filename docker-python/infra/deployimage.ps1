. $PSScriptRoot\common.ps1


function CreateResourceGroup {
    Write-Host "Creating resource group $Global:ResourceGroup"
    & az group create --name $Global:ResourceGroup --location  $Global:Location  | Out-Null
    ThrowErrorIfExitCode -Message "Could not create resource group $Global:ResourceGroup"
}

function CreateApplicationInsights{
    Write-Host "Going to create application insights $Global:ApplicationInsights"
    & az monitor app-insights component create --location $Global:Location --resource-group $Global:ResourceGroup --app $Global:ApplicationInsights
    ThrowErrorIfExitCode -Message "Could not create application insights $Global:ApplicationInsights"
}
function GetInstrumentationKey(){
    $json=az monitor app-insights component show --app $Global:ApplicationInsights --resource-group $Global:ResourceGroup
    $o= $json | ConvertFrom-Json
    return $o.instrumentationKey
}

CreateResourceGroup
CreateApplicationInsights
$instruKey=GetInstrumentationKey
Write-Host ("Instrumenttion key = {0}" -f $instruKey)
