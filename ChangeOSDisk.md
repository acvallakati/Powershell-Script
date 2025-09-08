#Define the following parameters.
$location = "AustraliaEast"
$resourceGroup = "auepssemprsg007"
$originalOsDiskName = "aueempprap007_OsDisk_1_584178e60bb742fe925b1ba9057e53d2"
$newOsDiskName = "aueempprap007dsk01"
$virtualMachineName = "aueempprap007"
#Get a list of all the managed disks in a resource group.
#Get-AzDisk -ResourceGroupName $resourceGroup | Select Name
#Get the source managed disk.
$sourceDisk = Get-AzDisk -ResourceGroupName $resourceGroup -DiskName $originalOsDiskName
#Create the disk configuration.
$diskConfig = New-AzDiskConfig -SourceResourceId $sourceDisk.Id -Location $sourceDisk.Location -CreateOption Copy -DiskSizeGB 127 -SkuName "StandardSSD_LRS"
#Create the new disk.
New-AzDisk -Disk $diskConfig -DiskName $newOsDiskName -ResourceGroupName $resourceGroup
#Swap the OS Disk out for the renamed disk.
$virtualMachine = Get-AzVm -ResourceGroupName $resourceGroup -Name $virtualMachineName
$newOsDisk = Get-AzDisk -ResourceGroupName $resourceGroup -Name $newOsDiskName
Set-AzVMOSDisk -VM $virtualMachine -ManagedDiskId $newOsDisk.Id -Name $newOsDisk.Name
Update-AzVM -ResourceGroupName $resourceGroup -VM $virtualMachine
#Delete the original disk.
Remove-AzDisk -ResourceGroupName $resourceGroup -DiskName $originalOsDiskName -Force
