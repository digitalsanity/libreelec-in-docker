#!/bin/bash

. config

echo "Removing files that break things .."

mkdir -p rootfs-excluded

sudo mv docker/rootfs/etc/init.d/S*mountboot rootfs-excluded/
sudo mv docker/rootfs/etc/init.d/S*network rootfs-excluded/
sudo mv docker/rootfs/etc/init.d/S*connman rootfs-excluded/
sudo mv docker/rootfs/etc/init.d/S*wifi rootfs-excluded/
sudo mv docker/rootfs/etc/init.d/S11share rootfs-excluded/
sudo mv docker/rootfs/etc/init.d/S*upgrade rootfs-excluded/
sudo mv docker/rootfs/etc/init.d/S*bluetooth rootfs-excluded/
sudo mv docker/rootfs/lost+found rootfs-excluded/

#/lib/systemd/system/*wants/ and  /etc/systemd/system/*wants/ d

sudo mv `sudo find ./docker/rootfs/ | grep systemd | grep wants | grep -i network | grep service` rootfs-excluded/
sudo mv `sudo find ./docker/rootfs/ | grep systemd | grep wants | grep bluetooth | grep service` rootfs-excluded/
sudo mv `sudo find ./docker/rootfs/ | grep systemd | grep wants | grep pulseaudio | grep service` rootfs-excluded/
sudo mv `sudo find ./docker/rootfs/ | grep systemd | grep wants | grep swap | grep service` rootfs-excluded/
sudo mv `sudo find ./docker/rootfs/ | grep systemd | grep wants | grep connman | grep service` rootfs-excluded/
sudo mv `sudo find ./docker/rootfs/ | grep systemd | grep wants | grep serial | grep service` rootfs-excluded/

sudo rm -rf docker/rootfs/dev/*
sudo mv docker/media rootfs-excluded/

sudo cp config docker/rootfs/.docker-config

echo "Building docker/Dockerfile for $name from docker/rootfs => $name-launcher/$name-launcher:local"

# sudo not needed here?
sudo docker build -t $name-launcher/$name-launcher:local docker

