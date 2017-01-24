#!/bin/bash

#TODO
kernel=$(uname -r)
release=$(cat /etc/*-release | grep VERSION)
nashome=/data/Documents/NAS
#This is not shared, as links to kernel build dir
kernhome=/data/kernel

#TODO: Detect version based on installed firmware
#For now, manually update these
gplurl=http://www.downloads.netgear.com/files/GPL/ReadyNASOS_V6.6.0_WW_src.zip
gplname=ReadyNASOS_V6.6.0_WW_src

mkdir -p $nashome
cd $nashome
cd files
wget $gplurl

mkdir $gplname
unzip $gplname*.zip -D $gplname/

sudo apt-get install build-essential libncurses5-dev
sudo mkdir -p $kernhome

kernvers=$(cd $gplname; ls -d linux-*x86_64)
ls -d $gplname/linux-*x86_64
sudo cp -R $gplname/linux-*x86_64 $kernhome
sudo rm /usr/src/linux
sudo ln -s $kernhome/$kernvers /usr/src/linux

export KERN_DIR=/usr/src/linux
cd /usr/src/linux
stamp=$(date -Iminutes)
sudo cp .config ".config-old-$stamp"
sudo cp arch/x86/configs/readynas_defconfig .config
sudo make clean
sudo make ARCH=x86_64
sudo make modules_install ARCH=x86_64

sudo modprobe configs
sudo cat /proc/config.gz | gunzip | grep config
