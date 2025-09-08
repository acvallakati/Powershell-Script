Link: https://learn.microsoft.com/en-us/azure/virtual-machines/extensions/update-linux-agent?WT.mc_id=Portal-Microsoft_Azure_Support&tabs=rhel

RHEL

#Check current Agent Version Linux
sudo yum list WAlinuxagent

#Check available Updates
sudo yum check-update WAlinuxagent

#Install the latest Packages
sudo yum Install WAlinuxagent -y

#Ensure auto update is enabled
sudo cat /etc/waagent.conf | grep -i autoupdate

#To enable the Auto Update
sudo sed -i 's/\# AutoUpdate.Enabled=y/AutoUpdate.Enabled=y/g' /etc/waagent.conf

#Restart the WAagent service
sudo systemctl restart waagent

#Validate waagent service is up and running
sudo systemctl status waagent