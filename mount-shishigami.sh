#!/usr/bin/env bash

GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m' 

sudo mkdir -p /mnt/shishigami
sudo mkdir -p /mnt/shishigami/media
sudo mkdir -p /mnt/shishigami/misc
sudo mkdir -p /mnt/shishigami/pictures
sudo mkdir -p /mnt/shishigami/portable-hdd


echo -e "${CYAN}Mounting shishigami...${NC}"

echo -n 'media: '
sudo mount -t nfs -o vers=4 shishigami:/volume1/media /mnt/shishigami/media 
echo -e "${GREEN}OK${NC}"

echo -n 'misc: '
sudo mount -t nfs -o vers=4 shishigami:/volume1/misc /mnt/shishigami/misc
echo -e "${GREEN}OK${NC}"

echo -n 'pictures: '
sudo mount -t nfs -o vers=4 shishigami:/volume1/pictures /mnt/shishigami/pictures
echo -e "${GREEN}OK${NC}"

echo -n 'portable-hdd: '
sudo mount -t nfs -o vers=4 shishigami:/volumeUSB1/usbshare /mnt/shishigami/portable-hdd
echo -e "${GREEN}OK${NC}"