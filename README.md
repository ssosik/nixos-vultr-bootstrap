# nixos-configs

Following this doc: https://www.vultr.com/docs/how-to-install-nixos-on-a-vultr-vps

Created custom ISO image from https://channels.nixos.org/nixos-21.05/latest-nixos-minimal-x86_64-linux.iso

## Temporarily enable SSH
Create an SSH key
```
ssh-keygen -t ed25519 -b 4096 -f .ssh/sosik -C '10/29/2021'
<password>
# Add the key
ssh-add .ssh/sosik
# Get the key fingerprint
ssh-add -L
```

On the Vultr VM web console <Send Clipboard>
```
mkdir .ssh
curl https://raw.githubusercontent.com/ssosik/nixos-configs/main/ssh.keys > ~/.ssh/authorized_keys
```

Then in iTerm with the SSH key loaded: `ssh nixos@8.9.11.190`

## Partition /dev/vda

Documentation: https://www.vultr.com/docs/how-to-install-nixos-on-a-vultr-vps#Create_the_File_System
GNU Parted Reference https://www.gnu.org/software/parted/manual/html_node/Running-Parted.html

Since I'm running with less than 4GB of RAM create a swap
```
parted /dev/vda 'mklabel msdos mkpart primary 1MiB -1GiB mkpart primary linux-swap -1GiB 100%'
parted -l
# Format the root partition
mkfs.ext4 -L root /dev/vda1
# Enable the swap
mkswap -L swap /dev/vda2
swapon /dev/vda2
mount /dev/disk/by-label/root /mnt
```
