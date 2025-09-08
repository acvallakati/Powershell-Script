{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "vmName": {
            "type": "string"
        },
        "vmSize": {
            "type": "string",
            "allowedValues": [
                "Standard_D4_v3",
                "Standard_E8s_v3",
                "Standard_E4s_v3",
                "Standard_D8s_v3",
                "Standard_E16as_v4",
                "Standard_B2s",
                "Standard_B2ms",
                "Standard_B4ms",
                "Standard_D2s_v3",
                "Standard_A4_v2",
                "Standard_D4as_v4",
                "Standard_D8s_v4",
                "Standard_D2ds_v5",
                "Standard_E20s_v3",
                "Standard_B1ls",
                "Standard_D4s_v3",
                "Standard_E2s_v3",
                "Standard_D2_v3",
                "Standard_A2",
                "Standard_D8_v3",
                "Standard_D8as_v4",
                "Standard_D2as_v4",
                "Standard_E16ds_v4",
                "Standard_E32s_v3",
                "Standard_E8as_v4",
                "Standard_D4s_v4",
                "Standard_D16s_v3",
                "Standard_E16ds_v5",
                "Standard_DS2_v2",
                "Standard_D2_v2",
                "Standard_B12ms",
                "Standard_E4as_v4",
                "Standard_B8ms",
                "Standard_E8ds_v4",
                "Standard_D16s_v5",
                "Standard_D8as_v5",
                "Standard_E16-8as_v4",
                "Standard_F8s_v2",
                "Standard_A2m_v2",
                "Standard_DS3_v2",
                "Standard_E2ds_v5",
                "Standard_D8ds_v5",
                "Standard_E8ds_v5",
                "Standard_D4ds_v4",
                "Standard_F4s_v2",
                "Standard_E16s_v5",
                "Standard_D4s_v5",
                "Standard_D2s_v5",
                "Standard_E4s_v5",
                "Standard_E2s_v5",
                "Standard_E8-4s_v4",
                "Standard_D4as_v5",
                "Standard_D4ds_v5",
                "Standard_D8_v4",
                "Standard_E16-8s_v4",
                "Standard_D4_v4",
                "Standard_E16s_v3",
                "Standard_M16ms",
                "Standard_DS4_v2",
                "Standard_F16s_v2",
                "Standard_A3",
                "Standard_A4m_v2",
                "Standard_A1",
                "Standard_A1_v2",
                "Standard_A2_v2",
                "Standard_DS14_v2",
                "Standard_E16s_v4",
                "Standard_B1ms",
                "Standard_B1s",
                "Standard_A0",
                "Standard_F8",
                "Standard_D4ads_v5"
            ]
        },
        "adminUsername": {
            "type": "string",
            "metadata": {
                "description": "Name for the Admin"
            }
        },
        "adminPassword": {
            "type": "securestring",
            "minLength": 12,
            "metadata": {
                "description": "Password for the Virtual Machine."
            }
        },
        "vnetName": {
            "type": "string",
            "allowedValues": [
                "auenpsvnt01"
            ],
            "metadata": {
                "description": "Name for the vNet"
            }
        },
        "platformSelection": {
            "type": "string",
            "defaultValue": "Windows",
            "allowedValues": [
                "Windows",
                "Linux"
            ],
            "metadata": {
                "description": "Select the OS type to deploy."
            }
        },
        "vnetResourceGroupName": {
            "type": "string",
            "allowedValues": [
                "auenpsrsg001"
            ],
            "metadata": {
                "description": "Name for the vnet RSG"
            }
        },
        "vmResourceGroupName": {
            "type": "string",
            "metadata": {
                "description": "Name for the VM RSG"
            }
        },
        "subnetName": {
            "type": "string",
            "allowedValues": [
                "auedvzsbt001"
            ],
            "metadata": {
                "description": "Name for the Subnet"
            }
        },
        "diskType": {
            "type": "string",
            "defaultValue": "Premium_LRS",
            "allowedValues": [
                "StandardSSD_LRS",
                "Standard_LRS",
                "Premium_LRS"
            ],
            "metadata": {
                "description": "The Storage type of the data Disks"
            }
        },
        "dataDisksCount": {
            "type": "int",
            "defaultValue": 0,
            "metadata": {
                "description": "This parameter allows the user to select the number of disks they want"
            }
        },
        "osDiskSize": {
            "type": "int",
            "defaultValue": 128
        },
        "dataDiskSize": {
            "type": "int"
        },
        "IPAllocationMethod": {
            "defaultValue": "Dynamic",
            "type": "string"
        },
        "privateIPAddress": {
            "type": "string"
        },
        "WinImagePublisher": {
            "defaultValue": "MicrosoftWindowsServer",
            "type": "string"
        },
        "WinImageOffer": {
            "defaultValue": "WindowsServer",
            "type": "string"
        },
        "WinOSVersion": {
            "defaultValue": "2016-Datacenter",
            "type": "string",
            "allowedValues": [
                "2008-R2-SP1",
                "2012-Datacenter",
                "2012-R2-Datacenter",
                "2016-Datacenter",
                "2019-Datacenter"
            ]
        },
        "availabilitySetname": {
            "type": "string"
        },
        "needAvailabilitySet": {
            "type": "string",
            "defaultValue": "No",
            "allowedValues": [
                "Yes",
                "No"
            ],
            "metadata": {
                "description": "Select whether the VM should be in an Availability set or not."
            }
        }
    },
    "variables": {
        "vnetId": "[resourceId(parameters('vnetResourceGroupName'),'Microsoft.Network/virtualNetworks', parameters('vnetName'))]",
        "subnetRef": "[concat(variables('vnetId'), '/subnets/', parameters('subnetName'))]",
        "vmNICPriName": "[concat(parameters('vmName'),'nic01')]",
        "vmNICPriID": "[resourceId(parameters('vmResourceGroupName'),'Microsoft.Network/networkInterfaces/', variables('vmNICPriName'))]",
        "availabilitySetId": {
            "id": "[resourceId(parameters('vmResourceGroupName'),'Microsoft.Compute/availabilitySets/', parameters('availabilitySetname'))]",
            "existing": "[resourceId(parameters('vmResourceGroupName'),'Microsoft.Network/avaiabilitySets',parameters('availabilitySetname'))]"
        },
        "copy": [
            {
                "name": "dataDisks",
                "count": "[if(equals(parameters('DataDisksCount'),0),1, parameters('DataDisksCount'))]",
                "input": {
                    "name": "[concat(parameters('vmName'),'dsk0',copyIndex('dataDisks',2))]",
                    "lun": "[copyIndex('dataDisks')]",
                    "createOption": "Empty",
                    "managedDisk": {
                        "storageAccountType": "[parameters('diskType')]"
                    },
                    "diskSizeGB": "[parameters('dataDiskSize')]"
                }
            }
        ]
    },
    "resources": [
        {
            "condition": "[equals(parameters('needAvailabilitySet'), 'Yes')]",
            "type": "Microsoft.Compute/availabilitySets",
            "apiVersion": "2018-10-01",
            "name": "[parameters('availabilitySetName')]",
            "location": "[resourceGroup().location]",
            "sku": {
                "name": "Aligned"
            },
            "properties": {
                "platformUpdateDomainCount": 5,
                "platformFaultDomainCount": 2,
                "virtualMachines": []
            }
        },
        {
            "type": "Microsoft.Compute/virtualMachines",
            "name": "[parameters('vmName')]",
            "apiVersion": "2018-10-01",
            "location": "[resourceGroup().location]",
            "dependsOn": [
                "[resourceId('Microsoft.Network/networkinterfaces/', variables('vmNICPriName'))]",
                "[resourceId('Microsoft.Compute/availabilitySets/', parameters('availabilitySetname'))]"
            ],
            "properties": {
                "availabilitySet": "[if(equals(parameters('needAvailabilitySet'), 'Yes'), variables('availabilitySetId'), json('null'))]",
                "hardwareProfile": {
                    "vmSize": "[parameters('vmSize')]"
                },
                "storageProfile": {
                    "imageReference": {
                        "publisher": "[parameters('WinImagePublisher')]",
                        "offer": "[ parameters('WinImageOffer')]",
                        "sku": "[ parameters('WinOSVersion')]",
                        "version": "latest"
                    },
                    "osDisk": {
                        "osType": "[parameters('platformSelection')]",
                        "name": "[concat(parameters('vmName'),'dsk01')]",
                        "createOption": "FromImage",
                        "caching": "ReadWrite",
                        "managedDisk": {
                            "storageAccountType": "[parameters('diskType')]"
                        },
                        "diskSizeGB": "[parameters('osDiskSize')]"
                    },
                    "dataDisks": "[if(equals(parameters('DataDisksCount'),0),json('null'),variables('dataDisks'))]"
                },
                "osProfile": {
                    "computerName": "[parameters('vmName')]",
                    "adminUsername": "[parameters('adminUsername')]",
                    "adminPassword": "[parameters('adminPassword')]"
                },
                "networkProfile": {
                    "networkInterfaces": [
                        {
                            "id": "[variables('vmNICPriID')]"
                        }
                    ]
                }
            }
        },
        {
            "type": "Microsoft.Network/networkInterfaces",
            "name": "[variables('vmNICPriName')]",
            "apiVersion": "2018-10-01",
            "location": "[resourceGroup().location]",
            "tags": {},
            "properties": {
                "ipConfigurations": [
                    {
                        "name": "ipconfig1",
                        "properties": {
                            "privateIPAddress": "[if(equals(parameters('IPAllocationMethod'), 'Static'),parameters('privateIPAddress'),json('null'))]",
                            "privateIPAllocationMethod": "[parameters('IPAllocationMethod')]",
                            "subnet": {
                                "id": "[variables('subnetRef')]"
                            },
                            "privateIPAddressVersion": "IPv4"
                        }
                    }
                ]
            },
            "dependsOn": []
        }
    ]
}