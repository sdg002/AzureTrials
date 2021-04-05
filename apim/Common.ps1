<#
    Use this functiont to create a template parameter for a route
#>
function CreateStringParameter($name,$description)
{
    $RID = New-Object -TypeName Microsoft.Azure.Commands.ApiManagement.ServiceManagement.Models.PsApiManagementParameter
    $RID.Name = $name
    $RID.Description = $description
    $RID.Type = "string"
    return $RID
}