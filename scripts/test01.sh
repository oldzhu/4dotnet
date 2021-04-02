#!/bin/bash

relpath=~/vm_releases/01-04-2021
mkdir -p $relpath/arm/tmpfs
sudo mount $relpath/arm/rootfs.ext2 $relpath/arm/tmpfs
sudo cp -u -v $HOME/buildroot/output/target/root/dotnethello/* $relpath/arm/tmpfs/root/dotnethello/
sudo umount $relpath/arm/tmpfs
rm -rf $relpath/arm/tmpfs
