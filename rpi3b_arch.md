# Set up Arch linux on Raspberry Pi 3 Model

## Prepare SD

```sh
# Grab image from https://archlinuxarm.org/about/downloads
wget http://os.archlinuxarm.org/os/ArchLinuxARM-rpi-armv7-latest.tar.gz

# Set up partitions
SD_DEVICE=/dev/sdb
sudo parted "$SD_DEVICE" --script -- mklabel msdos
sudo parted "$SD_DEVICE" --script -- mkpart primary fat32 1 128
sudo parted "$SD_DEVICE" --script -- mkpart primary ext4 128 100%
sudo parted "$SD_DEVICE" --script -- set 1 boot on
sudo mkfs.vfat -F32 "${SD_DEVICE}1"
sudo mkfs.ext4 -F "${SD_DEVICE}2"

# Mount
sudo mkdir -p /mnt/arch/{boot,root}
sudo mount "${SD_DEVICE}1" /mnt/arch/boot
sudo mount "${SD_DEVICE}2" /mnt/arch/root

# Copy image contents
sudo tar -xf ArchLinuxARM-rpi-armv7-latest.tar.gz -C /mnt/arch/root
sudo mv /mnt/arch/root/boot/* /mnt/arch/boot

# Unmount
sudo umount /mnt/arch/boot /mnt/arch/root
sudo eject "$SD_DEVICE"
```

## Bootstrap

```sh
pacman-key --init
pacman-key --populate archlinuxarm
pacman -Syyu --overwrite "*"
```

## Fix audio

Audio did not work out-of-the-box.
The line `dtparam=audio=on` had to be added, before `dtoverlay=vc4-kms-v3d`.

The full `/boot/config.txt` can be seen here:

```toml
# See /boot/overlays/README for all available options

initramfs initramfs-linux.img followkernel

display_auto_detect=1

# Uncomment to enable bluetooth
#dtparam=krnbt=on

# Fix audio - ordering here is important
dtparam=audio=on
dtoverlay=vc4-kms-v3d

[pi4]
# Run as fast as firmware / board allows
arm_boost=1
```

## Set up spotifyd

```sh
sudo pacman -S --no-confirm spotifyd
```

Create `$HOME/.config/spotifyd/spotifyd.conf` with contents:

```toml
[global]

username              = ""
password              = ""

backend               = "alsa"
device                = "default"
mixer                 = "PCM"
volume-controller     = "alsa"
device_name           = "raspberry-pi"
bitrate               = 320
cache_path            = "/opt/spotifyd/cache"
volume-normalisation  = true
normalisation-pregain = -10
```

```sh
# Ensure service is running when user is not logged in
sudo loginctl enable-linger "$USER" 
# Enable and start service
systemctl --user enable spotifyd.service --now
```
