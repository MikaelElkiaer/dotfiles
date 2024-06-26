# Bootstrapping

```bash
nix-shell -p git gnumake
mkdir --parents ~/Repositories/GitHub \
  && git clone --branch nix-wsl2 https://github.com/MikaelElkiaer/dotfiles ~/Repositories/GitHub/dotfiles \
  && make bootstrap
  && cd ~/Repositories/GitHub/dotfiles
```
