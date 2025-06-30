# Debian

## Install Microsoft Edge

```bash
curl -fSsL https://packages.microsoft.com/keys/microsoft.asc | sudo gpg --dearmor | sudo tee /usr/share/keyrings/microsoft-edge.gpg > /dev/null
echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft-edge.gpg] https://packages.microsoft.com/repos/edge stable main' | sudo tee /etc/apt/sources.list.d/microsoft-edge.list
sudo apt-get update
sudo apt-get install microsoft-edge-stable
```

## Install font

```bash
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/Noto.zip -O ~/Downloads/Noto.zip
unzip ~/Downloads/Noto.zip NotoSansMNerdFontMono-Regular.ttf
mv NotoSansMNerdFontMono-Regular.ttf ~/.local/share/fonts
fc-cache ~/.local/share/fonts
```

## Install Docker ([Source](https://docs.docker.com/engine/install/debian/#install-using-the-repository))

```bash
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker
```

## fscrypt

See [ArchWiki/Fscrypt](https://wiki.archlinux.org/title/Fscrypt) for details.

### Usage

```bash
# Unlock - using PAM passphrase
fscrypt unlock "$dir"
# Lock
fscrypt lock "$dir"
```

### Setup

#### Install

This is out of scope for Home Manager, as this requires system-level access.

```bash
# Debian
sudo apt install fscrypt
# Initial set-up
# - when prompted, do not enable world-writable
if ! sudo fscrypt status; then
  sudo fscrypt setup
else
  echo "[WRN] fscrypt already set up"
fi
```

#### Enable encryption on a device

For ext4, encryption must be enabled.
This must be done for any device that is targeted for encryption.

```bash
# Pick a device
device="$(lsblk --paths --fs | yank -g '/dev/[^ ]*')"
# Enable encryption
if ! sudo tune2fs -l $device | grep 'Filesystem features:' | grep --extended-regexp '[[:space:]]encrypt([[:space:]]|$)'; then
  sudo tune2fs -O encrypt "$device"
else
  echo "[WRN] Device $device already has encryption enabled"
fi
```

#### Encrypt directory

```bash
# Create or use an existing directory
dir="$HOME/.enc"
mkdir --parents "$dir"
# Encrypt directory
# - sudo needed when world-writable is not enabled
# - specify current user
# - use user password to unlock
if ! fscrypt status "$dir"; then
  sudo fscrypt encrypt --source=pam_passphrase --user="$(whoami)" "$dir"
else
  echo "[WRN] Directory $dir already encrypted"
fi
```
