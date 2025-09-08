#Connect-azaccount
$Subscriptions = Get-AzSubscription

foreach ($sub in $Subscriptions) {
    Select-AzSubscription -Subscription $sub.Id
    $disk = Get-AzDisk
    $ResourceGroupName = Get-AzResourceGroup
    foreach ($disk in $ResourceGroupName) {
    $disk = $ResourceGroupName.ResourceGroupName
    Write-Host "$disk unattached Disk copied to CSV file."
    Get-AzDisk | Where-Object { $_.ManagedBy -eq $null } | Select-Object ResourceGroupName, Name, Subscription | Export-Csv -path C:\ARM\UnusedDisk\"Unattached-disks-$(Get-Date -UFormat "%Y-%m-%d_%H-%m").csv" -append -force
    }
}
