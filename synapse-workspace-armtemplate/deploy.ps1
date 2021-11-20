$ErrorActionPreference="Stop"
Set-StrictMode -Version "latest"
Clear-Host


$ResourceGroup="rg-junk-synapsedeployment-using-arm-and-powershell"
$ResourceGroupManaged="rg-junk-synapsedeployment-using-arm-and-powershell-managed"
$Location="uksouth"
$StorageAccountName="junksynapsefromwrkstn"
$FileSystemName="junkfilesystemwrkstn"
$armFile=Join-Path -Path $PSScriptRoot -ChildPath ".\arm.json"
$currentSubscriptionid=(Get-AzContext).Subscription.Id
$sqlAdminUser="johndoe"
$sqlPassWord=[System.Guid]::NewGuid().ToString()
$WorkspaceName="armsynapse001fromwrkstn"
<#
Refer accompanying Readme.md about caveats about getting the id of the current user
You do not need to hard code the ID of the current user.
#>
$currentUserId="a4e9c07e-6f7e-4c5c-a10c-a1cca1800774"
<#
You should not create a new role assignment ID by using a Guid or a random string , Azure will resist creation of role assignments with identical properties.
https://github.com/Azure/azure-quickstart-templates/issues/4205
#>
$roleUniqueId="$StorageAccountName-roleid"

Write-Host "The admin user:$sqlAdminUser and password:'$sqlPassWord' will be used for the Synapse instance"
New-AzResourceGroup -Location $Location -Name $ResourceGroup -Force | Out-Null
Write-Host "Created new resource group $ResourceGroup at location $Location"

$armParameters=@{ 
    "name"= $WorkspaceName ; 
    "location"=$Location ;
    "defaultDataLakeStorageAccountName"=$StorageAccountName ;
    "defaultDataLakeStorageFilesystemName"=$FileSystemName ;
    "sqlAdministratorLogin"=$sqlAdminUser ;
    "sqlAdministratorLoginPassword"=$sqlPassWord ;
    "setWorkspaceIdentityRbacOnStorageAccount"=$true ;
    "createManagedPrivateEndpoint"=$false ;
    "defaultAdlsGen2AccountResourceId"="/subscriptions/$currentSubscriptionid/resourceGroups/$ResourceGroup/providers/Microsoft.Storage/storageAccounts/$StorageAccountName" ;
    "allowAllConnections"=$true ;
    "managedVirtualNetwork"="" ;
    "tagValues"=@{} ;
    "storageSubscriptionID"="$currentSubscriptionid" ;
    "storageResourceGroupName"="$ResourceGroup" ;
    "storageLocation"="$Location" ;
    "storageRoleUniqueId"=$roleUniqueId ;
    "isNewStorageAccount"=$true ;
    "isNewFileSystemOnly"=$false ;
    "adlaResourceId"="" ;
    "managedResourceGroupName"="$ResourceGroupManaged" ;
    "storageAccessTier"="Hot" ;
    "storageAccountType"="Standard_RAGRS" ;
    "storageSupportsHttpsTrafficOnly"=$true ;
    "storageKind"="StorageV2" ;
    "minimumTlsVersion"="TLS1_2" ;
    "storageIsHnsEnabled"=$true ;
    "userObjectId"=$currentUserId ;
    "setSbdcRbacOnStorageAccount"=$true ;
    "setWorkspaceMsiByPassOnStorageAccount"=$false ;
    "workspaceStorageAccountProperties"=@{} ;
}
Test-AzResourceGroupDeployment -ResourceGroupName $ResourceGroup -TemplateFile $armFile -TemplateParameterObject $armParameters

$deploymentName=("mysynapsedeployment-{0}" -f (Get-Date).Ticks)
New-AzResourceGroupDeployment -ResourceGroupName $ResourceGroup -TemplateFile $armFile -TemplateParameterObject $armParameters -Name $deploymentName -Verbose
Write-Host "Deployment complete"