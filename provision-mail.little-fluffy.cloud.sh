#!/bin/bash

sudo -s

# Parition and format /dev/vda
parted /dev/vda -s 'mklabel msdos mkpart primary 1MiB -1GiB mkpart primary linux-swap -1GiB 100%' && \
    parted -l && \
    mkfs.ext4 -L root /dev/vda1 && \
    mkswap -L swap /dev/vda2 && \
    swapon /dev/vda2 && \
    mount /dev/disk/by-label/root /mnt

# Create /etc/nixos configs from git repo
nixos-generate-config --root /mnt --dir /etc/nixos-tmp
cd /mnt/etc
nix-shell -p nixUnstable git
git clone https://github.com/ssosik/mail.little-fluffy.cloud.git nixos
cp nixos-tmp/hardware-configuration.nix nixos/.
rm -rf nixos-tmp
cd nixos

# Do the install
nixos-install --no-root-passwd --flake /mnt/etc/nixos#mail

echo "Remove the ISO and reboot the VM from the UI"
