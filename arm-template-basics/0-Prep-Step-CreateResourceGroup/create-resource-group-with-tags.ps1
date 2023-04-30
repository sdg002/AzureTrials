. $PSScriptRoot\..\common\variables.ps1


Write-Host "Going to create the resource group: '$Global:ResourceGroup' with the location: '$Global:Location' "
& az group create --location $Global:Location --name $Global:ResourceGroup --tags department=finance owner=johndoe@cool.com costcenter=eusales
RaiseCliError -message "Failed to create the resource group $Global:ResourceGroup"

