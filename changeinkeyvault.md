
    Select-AzSubscription -SubscriptionId 86016552-1a1c-4a54-b5ce-1aeed02a532e
    $keyvault = Get-AzKeyVault

    foreach ($kv in $keyvault) {

        ## Enable Soft-delete
        ($resource = Get-AzResource -ResourceId (Get-AzKeyVault -VaultName $kv.VaultName).ResourceId).Properties | Add-Member -MemberType "NoteProperty" -Name "enableSoftDelete" -Value "true"
        Set-AzResource -resourceid $resource.ResourceId -Properties $resource.Properties -Verbose -Force
    
       ## Enable PurgeProtection
        ($resource = Get-AzResource -ResourceId (Get-AzKeyVault -VaultName $kv.VaultName).ResourceId).Properties | Add-Member -MemberType "NoteProperty" -Name "enablePurgeProtection" -Value "true"
        Set-AzResource -resourceid $resource.ResourceId -Properties $resource.Properties -force -Verbose
    
    
    }
