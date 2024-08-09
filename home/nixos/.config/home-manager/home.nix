{
  config,
  pkgs,
  inputs,
  username,
  homeDirectory,
  ...
}:

let
  dotHome = "${config.home.homeDirectory}/Repositories/GitHub/dotfiles/home/nixos";
in
{
  imports = [ ./neovim.nix ];

  home.username = username;
  home.homeDirectory = homeDirectory;

  home.stateVersion = "24.05"; # WARN: Do not change

  home.packages = [
    pkgs.atuin
    pkgs.awscli2
    pkgs.cargo
    inputs.dagger.packages.${pkgs.system}.dagger
    pkgs.delta
    (
      with pkgs.dotnetCorePackages;
      combinePackages [
        dotnet_8.sdk
        sdk_6_0_1xx
      ]
    )
    pkgs.docker-credential-helpers
    pkgs.file
    pkgs.fluxcd
    pkgs.fzf
    pkgs.gh
    pkgs.gh-copilot
    pkgs.gh-markdown-preview
    pkgs.git
    pkgs.glow
    pkgs.go
    pkgs.gitmux
    pkgs.gnumake
    pkgs.hyperfine
    pkgs.k9s
    pkgs.kubectl
    pkgs.kubernetes-helm
    pkgs.kubeseal
    pkgs.kubeswitch
    pkgs.lazydocker
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
    pkgs.xclip
    pkgs.xdg-utils
    pkgs.yq-go
    pkgs.zoxide
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
    ".docker" = {
      recursive = true;
      source = config.lib.file.mkOutOfStoreSymlink "${dotHome}/.docker";
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

  home.sessionVariables = { };

  nix = {
    package = pkgs.nixFlakes;

    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
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
