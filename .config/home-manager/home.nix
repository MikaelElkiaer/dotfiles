{ config, pkgs, ... }:

{
  home.username = "nixos";
  home.homeDirectory = "/home/nixos";

  home.stateVersion = "24.05"; # WARN: Do not change

  home.packages = [
    pkgs.atuin
    pkgs.awscli2
    pkgs.cargo
    pkgs.delta
    pkgs.dotnet-sdk_8
    pkgs.file
    pkgs.fluxcd
    pkgs.gcc
    pkgs.gh
    pkgs.gitmux
    pkgs.gnumake
    pkgs.k9s
    pkgs.kubectl
    pkgs.kubernetes-helm
    pkgs.kubeseal
    pkgs.kubeswitch
    pkgs.lazygit
    pkgs.navi
    pkgs.neovim
    pkgs.nodejs
    pkgs.python3
    pkgs.ripgrep
    pkgs.skopeo
    pkgs.tmux
    pkgs.tree
    pkgs.unzip
    pkgs.vault
    pkgs.wget
    pkgs.wslu
    pkgs.xclip
    pkgs.yq-go
    pkgs.z-lua
  ];

  home.file = {
    ".config/home-manager" = {
      recursive = true;
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Repositories/GitHub/dotfiles/.config/home-manager";
    };
    ".config/navi" = {
      recursive = true;
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Repositories/GitHub/dotfiles/.config/navi";
    };
    ".config/nvim" = {
      recursive = true;
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Repositories/GitHub/nvim-config";
    };
    ".config/tmux" = {
      recursive = true;
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Repositories/GitHub/dotfiles/.config/tmux";
    };
    ".bash_aliases" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Repositories/GitHub/dotfiles/.bash_aliases";
    };
    ".bashrc_extra" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Repositories/GitHub/dotfiles/.bashrc";
    };
    ".gitconfig" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Repositories/GitHub/dotfiles/.gitconfig";
    };
    ".inputrc" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Repositories/GitHub/dotfiles/.inputrc";
    };
  };

  home.sessionVariables = {
  };

  nixpkgs.config.allowUnfree = true;

  programs.home-manager.enable = true;

  programs.bash = {
    enable = true;
    bashrcExtra = ''
      . ~/.bashrc_extra
    '';
  };
  programs.git.enable = true;
  programs.gpg.enable = true;
  programs.ssh.enable = true;
  services.gpg-agent.enable = true;
}
