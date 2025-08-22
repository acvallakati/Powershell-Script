###############################ARM 
#This script prepared for create, delete multi vM's os disk snapshot as well as data disk snapshots.      #
###########################################################################################################
#Created by: cAzure Cloud Team                                        #
###########################################################################################################
switch(Read-Host "Select a menu item 1/2/3/4
1. snapcreate
2. snapdelete
3. multisnapcreate
4. multisnapdelete
"){
   1 { snapcreate }
   2 { snapdelete }
   3 { multisnapcreate }
   4 { multisnapdelete }
       default {"Invalid entry"}
}
Function multisnapcreate {

    $path = Read-Host -Prompt 'Enter full path of csv file (ex: E:\data\xyz.csv '
    $file = Import-CSV -Path $path -Delimiter ","
    $nameLog = $path+$((Get-Date).ToString('dd-MM-yyyy-HH-mm')) +'.txt'
    $snapformatt = Read-Host -Prompt 'Enter snapshotname (ex: CTASK-ddmmyyyy) '
    $ErrorActionPreference="SilentlyContinue"
    Stop-Transcript | out-null
    $ErrorActionPreference = "Continue"
    Start-Transcript -Path $nameLog -Append     

    foreach ($vmsnap in $file)

    {

        $snapshotname = $vmsnap.name+'-'+$snapformatt

    if ($vmsnap.subscription -eq "Azure subscription 1") 
       
	   {
        echo "Please find $vmsnap.subscription vms snap details"
	    #Set Some Parameters.

        Select-AzSubscription -SubscriptionName $vmsnap.subscription

            #Get the VM.

            $vm = Get-AzVM `
              -ResourceGroupName $vmsnap.rg `
              -Name $vmsnap.name

            #Create the snapshot configuration. In this example, we are going to snapshot the OS disk

            $snapshot =  New-AzSnapshotConfig `
              -SourceUri $vm.StorageProfile.OsDisk.ManagedDisk.Id `
              -Location $vmsnap.location `
              -CreateOption copy

            
            #Take the snapshot.
             New-AzSnapshot `
               -Snapshot $snapshot `
               -SnapshotName $snapshotname `
               -ResourceGroupName $vmsnap.rg

               $datadisk = $vm.StorageProfile.DataDisks.ManagedDisk.Id

                    foreach ( $datasnap in $datadisk)
                    {
                        $snapname = $datasnap.split("/")[8]
                        $sname = $snapname
                        $nt = $sname+'-'+$snapformatt
                        #$path = 'C:\HealthCheck\Report'+'_'+$Server+'SCOM'+'.txt'
    
                        $snapshot =  New-AzSnapshotConfig `
                      -SourceUri $datasnap `
                      -Location $vmsnap.location `
                      -CreateOption copy

                        #Take the snapshot.
                        New-AzSnapshot `
                       -Snapshot $snapshot `
                       -SnapshotName $nt `
                       -ResourceGroupName $vmsnap.rg

                    }
            }
         elseif ($vmsnap.subscription -ne "Azure subscription 1") 
       
	        {
             echo "Please find $vmsnap.subscription vms snap details"
	         #Set Some Parameters.

                Select-AzSubscription -SubscriptionName $vmsnap.subscription

                #Get the VM.

                $vm = Get-AzVM `
                  -ResourceGroupName $vmsnap.rg `
                  -Name $vmsnap.name

                #Create the snapshot configuration. In this example, we are going to snapshot the OS disk

                $snapshot =  New-AzSnapshotConfig `
                  -SourceUri $vm.StorageProfile.OsDisk.ManagedDisk.Id `
                  -Location $vmsnap.location `
                  -CreateOption copy

                #Take the snapshot.
                 New-AzSnapshot `
                   -Snapshot $snapshot `
                   -SnapshotName $vmsnap.snapshot `
                   -ResourceGroupName $vmsnap.rg

                  $datadisk = $vm.StorageProfile.DataDisks.ManagedDisk.Id

                    foreach ( $datasnap in $datadisk)
                    {
                        $snapname = $datasnap.split("/")[8]
                        $sname = $snapname
                        $nt = $sname+'-'+$snapformatt
                        #$path = 'C:\HealthCheck\Report'+'_'+$Server+'SCOM'+'.txt'
    
                        $snapshot =  New-AzSnapshotConfig `
                      -SourceUri $datasnap `
                      -Location $vmsnap.location `
                      -CreateOption copy

                    #Take the snapshot.
                     New-AzSnapshot `
                       -Snapshot $snapshot `
                       -SnapshotName $nt `
                       -ResourceGroupName $vmsnap.rg

                    }
                }

    else 
        {
         echo "$vmsnap.name is not exist on portal"
         }
        }
    
        Stop-Transcript
}
Function multisnapdelete {


    $path = Read-Host -Prompt 'Enter full path of csv file (ex: E:\data\xyz.csv: '
    $file = Import-CSV -Path $path -Delimiter ","
    $nameLog = $path+$((Get-Date).ToString('dd-MM-yyyy-HH-mm')) +'.txt'
    $snapformatt = Read-Host -Prompt 'Enter snapshotname (ex: CTASK-ddmmyyyy) '
    $ErrorActionPreference="SilentlyContinue"
    Stop-Transcript | out-null
    $ErrorActionPreference = "Continue"
    Start-Transcript -Path $nameLog -Append
        

    foreach ($vmsnap in $file)
    {
        
        $snapshotname = $vmsnap.name+'-'+$snapformatt
    
        if ($vmsnap.subscription -eq "Azure subscription 1") 
       
	            {
                 echo "Please find $vmsnap.subscription vms snap details"
	             #Set Some Parameters.

                  Select-AzSubscription -SubscriptionName $vmsnap.subscription

                  Remove-AzSnapshot -ResourceGroupName $vmsnap.rg -SnapshotName $snapshotname -Force;

                  echo "$snapshotname has been deleted"

                  
                #Get the VM.

                $vm = Get-AzVM `
                  -ResourceGroupName $vmsnap.rg `
                  -Name $vmsnap.name

                  $datadisk = $vm.StorageProfile.DataDisks.ManagedDisk.Id

                    foreach ( $datasnap in $datadisk)
                    {
                        $snapname = $datasnap.split("/")[8]
                        $sname = $snapname
                        $nt = $sname+'-'+$snapformatt
                        Remove-AzSnapshot -ResourceGroupName $vmsnap.rg -SnapshotName $nt -Force;
                        echo "$nt has been deleted"
                    }
                }
                
                
         elseif ($vmsnap.subscription -ne "Base Infrastructure") 
       
	            {
                 echo "Please find $vmsnap.subscription vms snap details"
	             #Set Some Parameters.

                Select-AzSubscription -SubscriptionName $vmsnap.subscription
                Remove-AzSnapshot -ResourceGroupName $vmsnap.rg -SnapshotName $vmsnap.snapshot -Force;
                echo "$vmsnap.snapshot has been deleted"

                $vm = Get-AzVM `
                  -ResourceGroupName $vmsnap.rg `
                  -Name $vmsnap.name

                  $datadisk = $vm.StorageProfile.DataDisks.ManagedDisk.Id

                    foreach ( $datasnap in $datadisk)
                    {
                        $snapname = $datasnap.split("/")[8]
                        $sname = $snapname
                        $nt = $sname+'-'+$snapformatt
                        Remove-AzSnapshot -ResourceGroupName $vmsnap.rg -SnapshotName $nt -Force;
                        echo "$nt has been deleted"
                    }

                 }

    else 
                {
                 echo "$vmsnap.snapshot is not exist on portal"
                }
    }

    Stop-Transcript

}
Function snapdelete {



    $path = Read-Host -Prompt 'Enter full path of csv file (ex: E:\data\xyz.csv: '
    $file = Import-CSV -Path $path -Delimiter ","
    $nameLog = $path+$((Get-Date).ToString('dd-MM-yyyy-HH-mm')) +'.txt'
    $snapformatt = Read-Host -Prompt 'Enter snapshotname (ex: CTASK-ddmmyyyy) '
    $ErrorActionPreference="SilentlyContinue"
Stop-Transcript | out-null
$ErrorActionPreference = "Continue"
        Start-Transcript -Path $nameLog -Append
    foreach ($vmsnap in $file)
    {
       

        
        $snapshotname = $vmsnap.name+'-'+$snapformatt
    
        if ($vmsnap.subscription -eq "Base Infrastructure") 
       
	            {
                 echo "Please find $vmsnap.subscription vms snap details"
	             #Set Some Parameters.

                  Select-AzSubscription -SubscriptionName $vmsnap.subscription

                  Remove-AzSnapshot -ResourceGroupName $vmsnap.rg -SnapshotName $snapshotname -Force;

                  echo "$snapshotname has been deleted"

                }
                
                
         elseif ($vmsnap.subscription -ne "Base Infrastructure") 
       
	            {
                 echo "Please find $vmsnap.subscription vms snap details"
	             #Set Some Parameters.

                Select-AzSubscription -SubscriptionName $vmsnap.subscription
                Remove-AzSnapshot -ResourceGroupName $vmsnap.rg -SnapshotName $vmsnap.snapshot -Force;
                echo "$vmsnap.snapshot has been deleted"

                 }

    else 
                {
                 echo "$vmsnap.snapshot is not exist on portal"
                }
    }

  Stop-Transcript  

}
Function snapcreate {

    $path = Read-Host -Prompt 'Enter full path of csv file (ex: E:\data\xyz.csv: '
    $file = Import-CSV -Path $path -Delimiter ","
    $nameLog = $path+$((Get-Date).ToString('dd-MM-yyyy')) +'.txt'
    $snapformatt = Read-Host -Prompt 'Enter snapshotname (ex: CTASK-ddmmyyyy) '
    Start-Transcript -Path $nameLog -Append

    foreach ($vmsnap in $file)

    {
    
    $snapshotname = $vmsnap.name+'-'+$snapformatt

    if ($vmsnap.subscription -eq "Base Infrastructure") 
       
	    {
        echo "Please find $vmsnap.subscription vms snap details"
	    #Set Some Parameters.

         Select-AzSubscription -SubscriptionName $vmsnap.subscription

            #Get the VM.

            $vm = Get-AzVM `
              -ResourceGroupName $vmsnap.rg `
              -Name $vmsnap.name

            #Create the snapshot configuration. In this example, we are going to snapshot the OS disk

            $snapshot =  New-AzSnapshotConfig `
              -SourceUri $vm.StorageProfile.OsDisk.ManagedDisk.Id `
              -Location $vmsnap.location `
              -CreateOption copy

            
            #Take the snapshot.
             New-AzSnapshot `
               -Snapshot $snapshot `
               -SnapshotName $snapshotname `
               -ResourceGroupName $vmsnap.rg
        }
               
         elseif ($vmsnap.subscription -ne "Base Infrastructure") 
       
	        {
             echo "Please find $vmsnap.subscription vms snap details"
	         #Set Some Parameters.

                Select-AzSubscription -SubscriptionName $vmsnap.subscription

                #Get the VM.

                $vm = Get-AzVM `
                  -ResourceGroupName $vmsnap.rg `
                  -Name $vmsnap.name

                #Create the snapshot configuration. In this example, we are going to snapshot the OS disk

                $snapshot =  New-AzSnapshotConfig `
                  -SourceUri $vm.StorageProfile.OsDisk.ManagedDisk.Id `
                  -Location $vmsnap.location `
                  -CreateOption copy

                #Take the snapshot.
                 New-AzSnapshot `
                   -Snapshot $snapshot `
                   -SnapshotName $vmsnap.snapshot `
                   -ResourceGroupName $vmsnap.rg

           }

    else 
        {
         echo "$vmsnap.name is not exist on portal"
         }
    
}
Stop-Transcript
}