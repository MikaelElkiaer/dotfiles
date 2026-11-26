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

# GitHub signing key

`.gitconfig` already includes an override file `~/.github.gitconfig` which applies to repositories withing directory `~/Repositories/GitHub`.

In order to set up SSH signing for GitHub, do the following:

1. Generate a new SSH key for signing:

```bash
ssh-keygen -t ed25519 -C "$(git config get user.email)" -f ~/.ssh/id_ed25519-github
```

2. Add the private key to the SSH agent:

```bash
eval "$(ssh-agent -s)"
# On macOS, when using Apple keychain:
ssh-add --apple-use-keychain ~/.ssh/id_ed25519-github
# Otherwise:
ssh-add ~/.ssh/id_ed25519-github
```

3. Copy the public key, in order to add it to a GitHub account as a "SSH signing key":

```bash
pbcopy < ~/.ssh/id_ed25519-github.pub
```

4. Add the allowed signers file:

```bash
echo "$(git config get user.email) $(cat ~/.ssh/id_ed25519-github.pub)" > ~/.ssh/allowed_signers
```

5. Add the following to `~/.github.gitconfig`:

```ini
# vi:set ft=gitconfig:
[user]
  signingkey = ~/.ssh/id_ed25519-github.pub
[gpg]
  format = ssh
[commit]
  gpgsign = true
[gpg "ssh"]
  allowedSignersFile = ~/.ssh/allowed_signers
```

## Signoff

Not exactly related, but many projects will require signing off commits.
Be sure to commit using `git commit -s` (or `--signoff`).
When using `lazygit`, this is already enabled via `git.commit.signOff=true`.
