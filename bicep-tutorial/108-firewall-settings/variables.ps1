$Global:StorageAccount=("stosaudemofirewall{0}" -f $Global:environment)
$Global:Vnet="mvnet"
$Global:Subnet="subnet001"
$Global:AppPlan="asp-mycustomapp-$Global:environment-uks-001"
$Global:FirstFunctionApp="func-demoservice1-$Global:environment-uks-001"
$Global:FunctionStorageAccount=("stdemoservice{0}uks001" -f $Global:environment)
$Global:ApplicationInsights="appi-demosau-$Global:environment-uksouth-001"