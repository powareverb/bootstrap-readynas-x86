#!/bin/bash

#TODO: Check kernel is available
kernel=$(uname -r)
nashome=/data/Documents/NAS
vboxhome=/data/VirtualBox/

#TODO: Check and download required files
extpack=http://download.virtualbox.org/virtualbox/5.0.22/Oracle_VM_VirtualBox_Extension_Pack-5.0.22.vbox-extpack
guest=http://download.virtualbox.org/virtualbox/5.0.22/VBoxGuestAdditions_5.0.22.iso
#debinstall=http://download.virtualbox.org/virtualbox/5.0.22/virtualbox-5.0_5.0.22-108108~Debian~wheezy_amd64.deb
debinstall=http://download.virtualbox.org/virtualbox/5.0.22/virtualbox-5.0_5.0.22-108108~Debian~jessie_amd64.deb
phpvbox=https://sourceforge.net/projects/phpvirtualbox/files/phpvirtualbox-5.0-5.zip

cd $nashome/files/
wget -nc $debinstall
wget -nc $guest
wget -nc $extpack
wget -nc $phpvbox
unzip phpvirtualbox*.zip

#Run updates/installs
sudo apt-get update
#sudo apt-get install libgl1 libgl1-mesa-glx  libqt4-opengl libqtcore4 libqtgui4 libvpx1 libxinerama1
sudo apt-get install libgl1-mesa-glx libqt4-opengl libqtcore4 libqtgui4 libvpx1 libxinerama1

#TODO: Check existing
vboxexists=$(apt list --installed | grep virtualbox)

#TODO: Deal with versions
#sudo dpkg -i virtualbox-5.0_5.0.22-108108~Debian~wheezy_amd64.deb
sudo dpkg -i virtualbox-5.0_5.0.22-108108~Debian~jessie_amd64.deb

sudo VBoxManage extpack install Oracle_VM_VirtualBox_Extension_Pack-5.0.22.vbox-extpack
sudo adduser vboxuser vboxusers
sudo adduser admin vboxusers

#Check kernel mods running
vboxmods=$(lsmod | grep vbox)

#TODO: Deal with versions
sudo cp $nashome/files/phpvirtualbox-5.0.5/vboxinit /etc/init.d/vboxinit
sudo chmod u+rx /etc/init.d/vboxinit
sudo update-rc.d vboxinit defaults

sudo cp $nashome/phpvirtbox /etc/apache2/sites-available
sudo a2ensite phpvirtbox
sudo a2dissite phpvirtbox
sudo service apache2 reload

