# Overview
Demonstration of how to create Azure Synapse Workspace using ARM template


# How to get Object ID of current user?
Refer SFO https://stackoverflow.com/questions/68300678/how-can-i-determine-whether-i-am-signed-in-with-a-user-or-service-principal-in-a

```
function Get-CurrentAzUserObjectId {
   $objectId = $null
   $ctx = Get-AzContext
   if ($ctx.Account.Type -eq "User") {
       $u = Get-AzADUser -Mail $ctx.Account.Id
       $objectId = $u.Id
   }
   else {
       $sp = Get-AzADServicePrincipal -ApplicationId $ctx.Account.Id
       $objectId = $sp.Id
   }
   return $objectId
}
```
