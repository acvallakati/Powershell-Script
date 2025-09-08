#Provide the subscription Id of the subscription where snapshot exists
$sourceSubscriptionId='3c35bad4-fd51-4dea-89bc-30ac8ca1057f'

#Provide the name of your resource group where snapshot exists
$sourceResourceGroupName='auesbzinfrsg001'

#Provide the name of the snapshot
$snapshotName='testsnapshot'

#Set the context to the subscription Id where snapshot exists
Select-AzSubscription -SubscriptionId $sourceSubscriptionId

#Get the source snapshot
$snapshot= Get-AzSnapshot -ResourceGroupName $sourceResourceGroupName -Name $snapshotName

#Provide the subscription Id of the subscription where snapshot will be copied to
#If snapshot is copied to the same subscription then you can skip this step
$targetSubscriptionId='3c35bad4-fd51-4dea-89bc-30ac8ca1057f'

#Name of the resource group where snapshot will be copied to
$targetResourceGroupName='testwebrsg001'

#Set the context to the subscription Id where snapshot will be copied to
#If snapshot is copied to the same subscription then you can skip this step
Select-AzSubscription -SubscriptionId $targetSubscriptionId

#Source Resource ID of the Snapshot
$snapshot.Id='/subscriptions/3c35bad4-fd51-4dea-89bc-30ac8ca1057f/resourceGroups/testwebrsg001/providers/Microsoft.Compute/snapshots/testsnapshot'

#We recommend you to store your snapshots in Standard storage to reduce cost. Please use Standard_ZRS in regions where zone redundant storage (ZRS) is available, otherwise use Standard_LRS
#Please check out the availability of ZRS here: https://docs.microsoft.com/en-us/Az.Storage/common/storage-redundancy-zrs#support-coverage-and-regional-availability
$snapshotConfig = New-AzSnapshotConfig -SourceResourceId $snapshot.Id -Location $snapshot.Location -CreateOption Copy -SkuName Standard_LRS
$newsnapshotname= Read-Host -Prompt 'Enter new snapshot name'
#Create a new snapshot in the target subscription and resource group
New-AzSnapshot -Snapshot $snapshotConfig -SnapshotName $newsnapshotname -ResourceGroupName $targetResourceGroupName
