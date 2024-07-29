# Bootstrapping

## 1. Install NixOS WSL Distro

```pwsh
powershell -noexit ./01-wsl-install.ps1
```

## 2. Apply fixes to NixOS

```bash
bash ./02-nixos-upgrade.bash
```

## 3. Bootstrap config from this repository

```bash
nix-shell -p git gnumake
mkdir --parents ~/Repositories/GitHub \
  && git clone --branch nix-wsl2 https://github.com/MikaelElkiaer/dotfiles ~/Repositories/GitHub/dotfiles \
  && make bootstrap
  && cd ~/Repositories/GitHub/dotfiles
```
