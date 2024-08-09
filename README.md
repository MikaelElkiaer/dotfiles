# Bootstrapping

## Non-NixOS

```bash
cat <<EOF | xargs nix-shell --packages git gnumake --run
"mkdir --parents ~/Repositories/GitHub \
&& git clone https://github.com/MikaelElkiaer/dotfiles ~/Repositories/GitHub/dotfiles \
&& cd ~/Repositories/GitHub/dotfiles \
&& make hm-bootstrap"
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
cat <<-EOF | xargs nix-shell --packages git gnumake --run
"mkdir --parents ~/Repositories/GitHub \
&& git clone https://github.com/MikaelElkiaer/dotfiles ~/Repositories/GitHub/dotfiles \
&& cd ~/Repositories/GitHub/dotfiles \
&& make nix-bootstrap"
EOF
```
