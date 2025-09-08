$Data = @()
$Subscription="Non-Prod"
Set-AzContext -SubscriptionName "$Subscription" | Out-Null
$RGs = Get-AzResourceGroup

foreach ($RG in $RGs) {
    $VMs = Get-AzVM -ResourceGroupName $RG.ResourceGroupName
    foreach($VM in $VMs) {
        if (!$VM.LicenseType) {
            $LicenseType = "No_License"
        }
        else {
                $LicenseType = $VM.LicenseType 
        }

        $VMCustom = New-Object System.Object
        
        $VMCustom | Add-Member -Type NoteProperty -Name VMName -Value $VM.Name
        $VMCustom | Add-Member -Type NoteProperty -Name Subscription -Value $Subscription
        $VMCustom | Add-Member -Type NoteProperty -Name RGNAME -Value $VM.ResourceGroupName
        $VMCustom | Add-Member -Type NoteProperty -Name Location -Value $VM.Location
        $VMCustom | Add-Member -Type NoteProperty -Name OSType -Value $VM.StorageProfile.OSDisk.OSType
        $VMCustom | Add-Member -Type NoteProperty -Name LicenseType -Value $LicenseType

        $VMCustom
        $Data += $VMCustom
    } 
}

$Data | Export-CSV C:\ARM\Non-Prod.csv