$Subscriptions = Get-AzSubscription
foreach ($sub in $Subscriptions) {
    Select-AzSubscription -Subscription $sub.Id
    $NSG= Get-AzNetworkSecurityGroup
    $ResourceGroupName = Get-AzResourceGroup
    foreach ($NSG in $ResourceGroupName) {
    #$NSG = $ResourceGroupName.ResourceGroupName
    Write-Host "$ResourceGroupName Writing to CSV file."
    Get-AzNetworkSecurityGroup | Where-Object { $_.ManagedBy -eq $null } | Select-Object ResourceGroupName, Name | Export-Csv -path C:\ARM\NSG\"$($sub.name)-NSG.csv" -append -force
        }
}
