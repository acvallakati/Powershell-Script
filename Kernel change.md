https://learn.microsoft.com/en-us/answers/questions/918155/how-can-i-downgrade-the-kernel-version-of-ubuntu-o

sudo apt search linux-azure | grep 5.3.0-1009-azure
sudo apt install linux-image-5.3.0-1009-azure 