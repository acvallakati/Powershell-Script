$Subscriptions = Get-AzSubscription

foreach ($sub in $Subscriptions) 
{
    Select-AzSubscription -Subscription $sub.Id
    $group= Get-AzResourceGroup|select-object resourcegroupname
    ForEach ( $a IN $group ) 
   { 
        Get-AzRoleAssignment -ResourceGroupName $a | Select-Object $a.ResourceGroupName,RoleDefinitionName,ObjectType,DisplayName| Format-Table -AutoSize| Out-File -FilePath C:\ARM\Test\"$($sub.name).txt" -Append -Width 300
    }
}