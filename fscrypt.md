# fscrypt

See [ArchWiki/Fscrypt](https://wiki.archlinux.org/title/Fscrypt) for details.

## Usage

```bash
# Unlock - using PAM passphrase
fscrypt unlock "$dir"
# Lock
fscrypt lock "$dir"
```

## Setup

### Install

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

### Enable encryption on a device

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

### Encrypt directory

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
