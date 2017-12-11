#!/usr/bin/env bash

GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m' 

sudo mkdir -p /mnt/shishigami
sudo mkdir -p /mnt/shishigami/misc
sudo mkdir -p /mnt/shishigami/movies
sudo mkdir -p /mnt/shishigami/pictures
sudo mkdir -p /mnt/shishigami/series
sudo mkdir -p /mnt/shishigami/tmp


echo -e "${CYAN}Mounting shishigami...${NC}"

echo -n 'misc: '
sudo mount -t nfs -o vers=4 shishigami:/volume1/misc /mnt/shishigami/misc
echo -e "${GREEN}OK${NC}"

echo -n 'movies: '
sudo mount -t nfs -o vers=4 shishigami:/volume1/movies /mnt/shishigami/movies 
echo -e "${GREEN}OK${NC}"

echo -n 'pictures: '
sudo mount -t nfs -o vers=4 shishigami:/volume1/pictures /mnt/shishigami/pictures
echo -e "${GREEN}OK${NC}"

echo -n 'series: '
sudo mount -t nfs -o vers=4 shishigami:/volume1/series /mnt/shishigami/series
echo -e "${GREEN}OK${NC}"

echo -n 'tmp: '
sudo mount -t nfs -o vers=4 shishigami:/volume1/tmp /mnt/shishigami/tmp
echo -e "${GREEN}OK${NC}"
