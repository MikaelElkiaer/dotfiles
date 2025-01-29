# Bootstrapping

## Non-NixOS

### 1. [Install Nix](https://nixos.org/download/)

```bash
sh <(curl -L https://nixos.org/nix/install) --daemon
[ -f ~/.config/nix/nix.conf ] ||
  echo 'extra-experimental-features = flakes nix-command' > ~/.config/nix/nix.conf
```

### 2. Clone repo and apply Home-Manager config

```bash
CLONE_LOCATION="~/Repositories/GitHub"
cat <<EOF | xargs nix-shell --packages git --run
"mkdir --parents $CLONE_LOCATION \
&& git clone https://github.com/MikaelElkiaer/dotfiles $CLONE_LOCATION/dotfiles \
&& cd $CLONE_LOCATION/dotfiles \
&& nix run home-manager/release-24.11 -- switch -b bak --flake $PWD/home/nixos/.config/home-manager/"
EOF
```

## NixOS (WSL)

### 1. Install NixOS WSL Distro

In PowerShell:

```powershell
# Go to home
cd $env:USERPROFILE\
# Download latest NixOS WSL release
Invoke-WebRequest https://github.com/nix-community/NixOS-WSL/releases/download/2311.5.3/nixos-wsl.tar.gz
# Import distro
wsl --import NixOS NixOS\ nixos-wsl.tar.gz
# Start distro
wsl -d NixOS
```

### 2. Apply fixes to NixOS

In WSL:

```bash
# Switch channel to unstable
# - Alternatively, switch to latest stable:
#   `sudo nix-channel --add  https://nixos.org/channels/nixos-24.11 nixos`
sudo nix-channel --add  https://nixos.org/channels/nixos-unstable nixos
sudo sed -i -E 's/(system\.stateVersion = ")(.*)(")/\124.11\3/g' /etc/nixos/configuration.nix
# Get updates from channel
sudo nix-channel --update
# Rebuild and upgrade packages using channel
sudo nixos-rebuild switch --upgrade
```

### 3. Bootstrap config from this repository

```bash
CLONE_LOCATION="~/Repositories/GitHub"
cat <<EOF | xargs nix-shell --packages git gnumake --run
"mkdir --parents $CLONE_LOCATION \
&& git clone https://github.com/MikaelElkiaer/dotfiles $CLONE_LOCATION/dotfiles \
&& cd $CLONE_LOCATION/dotfiles \
&& sudo cp $$PWD/etc/nixos/configuration.nix /etc/nixos/configuration.nix \
&& sudo nixos-rebuild switch \
&& home-manager switch -b bak --flake $$PWD/home/nixos/.config/home-manager/"
EOF
```
