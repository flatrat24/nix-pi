# Introduction
This repository is a flake to generate an image for a Raspberry Pi 4. I personally use it to configure a NixOS media server using JellyFin, but I'm sure it can be easily changed around to fit another use case in `configuration.nix`.

# Guide

Evaluate the nix flake to generate the sd image with the following command. Run it in the directory of the flake:
```
nix run nixpkgs#nixos-generators -- -f sd-aarch64 --flake .#pi --system aarch64-linux -o ./pi.sd
```
The image generates as a .zst compressed file. Before putting it onto the sd card, it must be decompressed. To do so, first you must make a copy of the file. All this command does is copy the file from the nix store to the flake directory. This is done because decompressing the file with `unzstd` requires a write-enabled file.
```
cp $(find pi.sd/sd-image -mindepth 1) $(find pi.sd/sd-image -mindepth 1 | awk -F'/' '{print $NF}')
```
Once the file is copied, run the next command to decompress the image. It finds the file copied with the previous command and decompresses it.
```
unzstd $(find . -type f -name 'nixos-image-sd-card-*.img.zst')
```
Lastly, putting the image onto the sd card. Before running the command, make sure to replace `<path/to/drive>` with the actual path. You can find it with `lsblk`. This is what my lsblk output looks like, and I end up using `/dev/sda2`:
```
NAME        MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS
sda           8:0    1  14.4G  0 disk 
├─sda1        8:1    1    30M  0 part /run/media/ea/FIRMWARE
└─sda2        8:2    1  14.4G  0 part /run/media/ea/NIXOS_SD
nvme0n1     259:0    0 465.8G  0 disk 
├─nvme0n1p1 259:1    0   512M  0 part /boot
├─nvme0n1p2 259:2    0 448.8G  0 part /nix/store
│                                     /
└─nvme0n1p3 259:3    0  16.4G  0 part [SWAP]
```
Once you make that replacement, run the command.
```
sudo dd if="$(find . -type f -name 'nixos-image-sd-card-*.img.zst')" of=/dev/sda2 bs=10MB oflag=dsync status=progress
```

# Useful Links
These are all articles that I referenced throughout this process:
    - [Janissary's Blod](https://blog.janissary.xyz/posts/nixos-install-custom-image)
    - [More in depth GitHub repository similar to this one](https://github.com/lucernae/nixos-pi)
    - [rbf.dev's blog](https://rbf.dev/blog/2020/05/custom-nixos-build-for-raspberry-pis/#nix-packages-and-image-configuration)
    - [NixOS Wiki article on compiling for ARM](https://nixos.wiki/wiki/NixOS_on_ARM)
