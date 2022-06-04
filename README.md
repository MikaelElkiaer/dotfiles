# Bootstrapping

This assumes that a running version of EndeavourOS has already been installed - it does not need to be a fresh installation.
First step is to clone this repo, e.g.:

`mkdir -p ~/Repositories/GitHub && git clone -b endeavouros https://github.com/MikaelElkiaer/dotfiles ~/Repositories/GitHub/dotfiles && cd ~/Repositories/GitHub/dotfiles`

Second step is to run the `install.sh` script:

`./install.sh`

## Next steps

1. (Re-)join [Brave sync chain](https://support.brave.com/hc/en-us/articles/360021218111-How-do-I-set-up-Sync-).
2. Log into Bitwarden [browser extension](https://chrome.google.com/webstore/detail/bitwarden-free-password-m/nngceckbapebfimnlniiiahkandclblb) and [CLI](https://bitwarden.com/help/cli/).
3. Run additonal scripts from `./_scripts`.
