# Go to home
cd $env:USERPROFILE\
# Download latest NixOS WSL release
Invoke-WebRequest https://github.com/nix-community/NixOS-WSL/releases/download/2311.5.3/nixos-wsl.tar.gz
# Import distro
wsl --import NixOS NixOS\ nixos-wsl.tar.gz
# Start distro
wsl -d NixOS
