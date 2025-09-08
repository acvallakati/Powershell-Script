$Subscription = Get-AzSubscription
foreach ($sub in $subscription) {
    Select-AzSubscription -SubscriptionId $sub.Id
    $keyvault = Get-AzKeyVault

    foreach ($kv in $keyvault) {
    Get-AzKeyVault -VaultName $kv.VaultName |Select-Object  VaultName, EnableSoftDelete, EnablePurgeProtection | Export-Csv -path C:\ARM\NSG\"$($sub.name)-keyvault.csv" -append -force
    }
}