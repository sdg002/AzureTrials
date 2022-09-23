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

function CreateContainerRegistry{
    Write-Host "Creating container registry $ContainerRegistry"
    & az acr create --resource-group $Global:ResourceGroup --name $ContainerRegistry --sku Basic --admin-enabled true
    ThrowErrorIfExitCode -Message "Could not create container group $ContainerRegistry"
    Write-Host "ContainerRegistry $ContainerRegistry created"
}

function AssignIdentityToAcr{
    Write-Host "Fetching identity of the Azure Container registry $ContainerRegistry"
    $identityJson=& az acr identity show --name $ContainerRegistry
    if ($identityJson)
    {
        Write-Host "Found an existing identity. The identity of the ACR is: "
        Write-Host $identityJson  
        $identity=$identityJson | ConvertFrom-Json

        if ($identity.type -ne "systemAssigned")
        {
            Write-Error -Message "The specified Azure Container Registry already has a non-system identity. This should be manually removed . We want system only"
        }
        Write-Host ("It appears that there is already a system assigned identity, type={0}. So not taking any further action" -f $identity.type)
    }
    else {
        Write-Host "Assigning system identity to ACR $ContainerRegistry"
        & az acr identity assign --name  $ContainerRegistry --identities "[system]" --resource-group $ResourceGroup
        ThrowErrorIfExitCode -Message "Could not assign System identity to  $ContainerRegistry"            
    }
}

CreateResourceGroup
CreateApplicationInsights
$instruKey=GetInstrumentationKey
Write-Host ("Instrumenttion key = {0}" -f $instruKey)
CreateManagedIdentity
CreateContainerRegistry
AssignIdentityToAcr


<#
you were here




Step 2
------

Write a script that will create a new container group
    Name this script as UploadDockerImage.ps1
    You will need to follow https://learn.microsoft.com/en-us/cli/azure/container?view=azure-cli-latest#az-container-create
    You need to specify the registry server and password

    az container create -g MyResourceGroup --name myapp --image myAcrRegistry.azurecr.io/myimage:latest --registry-password password

Refer the files here C:\Users\saurabhd\MyTrials\AzureStuff\Docker

Step 3
------
The container has to be started
    See this https://learn.microsoft.com/en-us/cli/azure/container?view=azure-cli-latest#az-container-start
    az container start --name
                   --resource-group
                   [--no-wait]
    Test
    ----
        Run from CMD and you should see logging to Application Insights
        Try logging some more stuff like environment all variables

Step 4 (No - do not go here.. Becomes too complex. Run the Python in a for loop, use a delay provided by the environment variables)
------
    Create an Azure batch account
    See what you did in Azure batch
    C:\Users\saurabhd\MyTrials\AzureStuff\batch-services
    & az batch account create --name $BatchAccount --location $Global:Location --resource-group $Global:BatchServicesResourceGroup --storage-account $StorageAccountBachServices --identity-type "SystemAssigned"

Step 5 (No - do not go here. See reasons above)
------
    Schedule the image to run every 1 minute

#>