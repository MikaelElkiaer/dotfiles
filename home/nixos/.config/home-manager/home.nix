{ config, pkgs, ... }:

let
  dotHome = "${config.home.homeDirectory}/Repositories/GitHub/dotfiles/home/nixos";
in
{
  imports = [
    ./neovim.nix
  ];

  home.username = "nixos";
  home.homeDirectory = "/home/nixos";

  home.stateVersion = "24.05"; # WARN: Do not change

  home.packages = [
    pkgs.atuin
    pkgs.awscli2
    pkgs.cargo
    (builtins.getFlake "github:dagger/nix/08aa7a30f2cd6ae56a02f6a489485cd15a92313e").packages.${pkgs.system}.dagger
    pkgs.delta
    pkgs.dotnet-sdk_8
    pkgs.file
    pkgs.fluxcd
    pkgs.gh
    pkgs.git
    pkgs.go
    pkgs.gitmux
    pkgs.gnumake
    pkgs.k9s
    pkgs.kubectl
    pkgs.kubernetes-helm
    pkgs.kubeseal
    pkgs.kubeswitch
    pkgs.lazygit
    pkgs.navi
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
      source = config.lib.file.mkOutOfStoreSymlink "${dotHome}/.config/home-manager";
    };
    ".config/lazygit" = {
      recursive = true;
      source = config.lib.file.mkOutOfStoreSymlink "${dotHome}/.config/lazygit";
    };
    ".config/navi" = {
      recursive = true;
      source = config.lib.file.mkOutOfStoreSymlink "${dotHome}/.config/navi";
    };
    ".config/tmux" = {
      recursive = true;
      source = config.lib.file.mkOutOfStoreSymlink "${dotHome}/.config/tmux";
    };
    ".bash_aliases" = {
      source = config.lib.file.mkOutOfStoreSymlink "${dotHome}/.bash_aliases";
    };
    ".bashrc_extra" = {
      source = config.lib.file.mkOutOfStoreSymlink "${dotHome}/.bashrc";
    };
    ".gitconfig" = {
      source = config.lib.file.mkOutOfStoreSymlink "${dotHome}/.gitconfig";
    };
    ".inputrc" = {
      source = config.lib.file.mkOutOfStoreSymlink "${dotHome}/.inputrc";
    };
    "bin" = {
      recursive = true;
      source = config.lib.file.mkOutOfStoreSymlink "${dotHome}/bin";
    };
  };

  home.sessionVariables = {
  };

  nix = {
    package = pkgs.nixFlakes;

    settings.experimental-features = [ "nix-command" "flakes" ];
  };

  nixpkgs.config.allowUnfree = true;

  programs.home-manager.enable = true;

  programs.bash = {
    enable = true;
    bashrcExtra = ''
      . ~/.bashrc_extra
    '';
  };
  programs.gpg.enable = true;
  services.gpg-agent.enable = true;
}
