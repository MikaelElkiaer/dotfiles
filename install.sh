#!/bin/sh

# Update mirrors (Sweden is fastest)
sudo pacman-mirrors -c Sweden

# Config
chsh -s /usr/bin/zsh

# Install yay
sudo pacman --noconfirm -S git openssh base-devel
git clone https://aur.archlinux.org/yay-git.git ~/yay-git
bash -c "cd ~/yay-git && makepkg --noconfirm -si && yay -Syu && cd ~ && rm -rf ~/yay-git"

# Install CLI tools
sudo pacman --noconfirm -S git openssh bat exa fd tldr neovim htop fzf ripgrep lazygit
yay --noconfirm -S git-delta-bin gotop-bin

# k8s tools
sudo pacman --noconfirm -S kubectl kubectx k9s fluxctl
yay --noconfirm -S google-cloud-sdk kubeseal-bin

# docker
sudo pacman --noconfirm -S docker
systemctl start docker
systemctl enable docker
sudo usermod -aG docker $USER

# Manjaro specifics 
sudo pacman --noconfirm -S polybar dunst xclip rofi autorandr brave vscode gcc manjaro-settings-manager chromium signal-desktop github-cli yq slop ranger
yay --noconfirm -S nerd-fonts-dejavu-complete visual-studio-code-bin google-chrome slack-desktop i3lock-color rxvt-unicode-pixbuf
sudo rsync -r /usr/share/ /usr/share

# Extra Manjaro rice
sudo pacman --noconfirm -S python xorg-xprop python-pip
pip install --user i3ipc
pip install --user fontawesome
git clone git@github.com:MikaelElkiaer/i3-warp-mouse.git ~/Repositories/GitHub/i3-warp-mouse
git clone git@github.com:MikaelElkiaer/i3scripts.git ~/Repositories/GitHub/i3scripts
git clone git@github.com:gawen947/i3-quaketerm.git ~/Repositories/GitHub/i3-quaketerm

# wol
nmcli c modify $WIRED 802-3-ethernet.wake-on-lan magic
sudo sed -i "s/#?\(WOL_DISABLE=\)[YN]/\1Y/" /etc/tlp.conf

# xrdp
yay -S xrdp xorgxrdp
sudo echo 'allowed_users=anybody' >> /etc/X11/Xwrapper.config
sudo systemctl enable xrdp --now
sudo systemctl enable xrdp-sesman --now
## -layout and something else in /etc/xrdp/sesman.ini

# bluetooth
yay -S blueman
systemctl enable bluetooth --now
## set AutoEnable=true in /etc/bluetooth/main.conf

# audio
install_pulse

# Fix time if dualboot with Windows
timedatectl set-local-rtc 1 --adjust-system-clock

# SSH
read EMAIL
ssh-keygen -t ed25519 -C $EMAIL
eval "$(ssh-agent -s)"

# .NET
wget https://dot.net/v1/dotnet-install.sh && chmod +x dotnet-install.sh
./dotnet-install.sh --channel 2.1 --version latest --install-dir /opt/dotnet
./dotnet-install.sh --channel 3.1 --version latest --install-dir /opt/dotnet
./dotnet-install.sh --channel 5.0 --version latest --install-dir /opt/dotnet

