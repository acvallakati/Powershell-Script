# Link https://charbelnemnom.com/vm-agent-is-unable-to-communicate-with-the-azure-backup-service-for-linux-vms/?utm_content=expand_article

#UBUNTU

# Check the Linux Agent Version
waagent --version

# Update package cache via bash
sudo apt-get -qq Update

# Install latest agent package
sudo apt-get install walinuxagent (Press Yes Y to install)

# Verify Current Linux Agent package
apt list --installed | grep walinuxagent

# To enable ‘Auto Update’ on your Linux VM, please run the following command:
sudo sed -i 's/# AutoUpdate.Enabled=n/AutoUpdate.Enabled=y/g' /etc/waagent.conf

# To check whether ‘Auto Update’ is enabled, you can run the following command:
cat /etc/waagent.conf

# Restart waagengt service for Ubuntu 16.04 / 17.04
sudosystemctl restart walinuxagent.service






