#!/usr/bin/env bash

GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m' 

sudo mkdir -p /mnt/kamajii
sudo mkdir -p /mnt/kamajii/complete
sudo mkdir -p /mnt/kamajii/incomplete
sudo mkdir -p /mnt/kamajii/nzb


echo -e "${CYAN}Mounting kamajii...${NC}"

echo -n 'complete: '
sudo mount -t nfs -o vers=4 kamajii:/srv/nfs/complete /mnt/kamajii/complete
echo -e "${GREEN}OK${NC}"

echo -n 'incomplete: '
sudo mount -t nfs -o vers=4 kamajii:/srv/nfs/incomplete /mnt/kamajii/incomplete 
echo -e "${GREEN}OK${NC}"

echo -n 'nzb: '
sudo mount -t nfs -o vers=4 kamajii:/srv/nfs/nzb /mnt/kamajii/nzb
echo -e "${GREEN}OK${NC}"
