# Bootstrapping

## Non-NixOS

```bash
CLONE_LOCATION="~/Repositories/GitHub"
cat <<EOF | xargs nix-shell --packages git gnumake --run
"mkdir --parents $CLONE_LOCATION \
&& git clone https://github.com/MikaelElkiaer/dotfiles $CLONE_LOCATION/dotfiles \
&& cd $CLONE_LOCATION/dotfiles \
&& nix run home-manager/release-24.05 -- switch -b bak --flake $PWD/home/nixos/.config/home-manager/"
EOF
```

## NixOS (WSL)

### 1. Install NixOS WSL Distro

```pwsh
powershell -noexit ./01-wsl-install.ps1
```

### 2. Apply fixes to NixOS

```bash
bash ./02-nixos-upgrade.bash
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
