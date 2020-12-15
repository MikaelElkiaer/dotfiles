# Setting up WSL2, Arch, Docker, Windows Terminal, and other tooling

## Installing WSL2

Follow the guide: [Windows Subsystem for Linux Installation Guide for Windows 10](https://docs.microsoft.com/en-us/windows/wsl/install-win10).
1. Enable Windows Subsystem for Linux via Powershell:
```powershell
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
```
2. [Update to the latest version of Windows](ms-settings:windowsupdate)
3. Enable Virtual Machine feature:
```powershell
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
```
4. Restart, then [download and install the Linux kernel update package](https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi)
5. Set WSL 2 as your default version:
```powershell
wsl --set-default-version 2
```
6. Install and configure Linux distro (see next section for setting up Arch)

## Installing and configuring Arch (inspired by [ld100](https://gist.github.com/ld100/3376435a4bb62ca0906b0cff9de4f94b))

1. Download [ArchWSL](https://github.com/yuk7/ArchWSL) and run the installer (.exe).
2. Initialize package manager and update packages:
```
pacman-key --init
pacman-key --populate
pacman -Syu
```
3. Install zsh:
```
pacman -S zsh
```
4. Create non-root user:
* Add a sudo group: `groupadd sudo`
* Enable sudoers: `vim /etc/sudoers` and uncomment lines `%wheel ALL=(ALL) NOPASSWD: ALL` and `%sudo   ALL=(ALL) ALL`
* Add new admin user: `useradd -m -G wheel,sudo -s /bin/zsh <username>`, use `-s /bin/bash` if you want bash instead of zsh.
* Set password for the new user: `passwd <username>`
* Run Windows command shell, go to the directory with Arch Linux, run `Arch.exe config --default-user <username>`.

## Installing Windows tools

1. Install Windows Terminal via Microsoft Store
2. Install a [NerdFonts font](https://www.nerdfonts.com/font-downloads)
3. Install [Docker Desktop](https://www.docker.com/products/docker-desktop)
4. Install [PowerToys](https://github.com/microsoft/PowerToys)

## Additional tools and glamour

### Yay (AUR+Pacman helper)
* Just follow [How to Install Yay AUR Helper in Arch Linux and Manjaro](https://www.tecmint.com/install-yay-aur-helper-in-arch-linux-and-manjaro/) guide:
* `sudo pacman -S git openssh`
* `sudo pacman -S base-devel` - when asked question on fakeroot and fakeroot-tcp choose to leave fakeroot-tcp and not install fakeroot
* `git clone https://aur.archlinux.org/yay-git.git`
* `cd yay-git`
* `makepkg -si`
* Run `yay -Syu` to update all AUR packages and reinstall fakeroot-tcp (will install the latest version)
* Remove the leftovers: `rm -rf ~/yay-git`

### Tools for proper terminal experience
```
sudo pacman -Sy git openssh bat exa fd tldr neovim htop diff-so-fancy wget fzf ripgrep
yay git-delta
```

### Oh-my-zsh with theme and plugins
```
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/agkozak/zsh-z ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-z
git clone https://github.com/softmoth/zsh-vim-mode.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-vim-mode
```

### Tungsten (Wolfram Alpha API via CLI)

1. Install tungsten: `yay tungsten`
2. Get API key from http://developer.wolframalpha.com/portal/myapps/
3. Put API key in `~/.wolfram_api_key`
4. Run tungsten commands, e.g. `tungsten what is the meaning of life`
