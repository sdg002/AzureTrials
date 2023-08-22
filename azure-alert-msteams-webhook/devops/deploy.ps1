. $PSScriptRoot/commonvariables.ps1


# YOU WERE HERE
# BRING IN ALL ARM TEMPLATES , 
# PUT THE TEMPLATE+PARAMETER FILES IN THEIR RESPSECTIVE SUB-FOLDERS

<#
Deploy resource group
#>
Write-Host "Going to create the resource group: '$Global:ResourceGroup' with the location: '$Global:Location' "
& az group create --location $Global:Location --name $Global:ResourceGroup `
    --tags  location=$Global:Location
RaiseCliError -message "Failed to create the resource group $Global:ResourceGroup"


