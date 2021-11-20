$ErrorActionPreference="Stop"
Set-StrictMode -Version "latest"
Clear-Host

<#
Demonstrates how to update the Admin password of the Synapse Workspace
#>

$ResourceGroup="rg-junk-synapsedeployment-using-arm-and-powershell"
Write-Host "Finding Synapse resource(s) in the resource group $ResourceGroup"
$synapseResources=Get-AzResource -ResourceGroupName $ResourceGroup -ResourceType "Microsoft.Synapse/workspaces"
Write-Host ("Found Synapse resource:{0}" -f $synapseResources[0].Name)

$newPassword=Read-Host -Prompt "Please type the new password"
$securePassword = ConvertTo-SecureString $newPassword -AsPlainText -Force
Update-AzSynapseWorkspace -ResourceId $synapseResources[0].ResourceId -SqlAdministratorLoginPassword $securePassword

