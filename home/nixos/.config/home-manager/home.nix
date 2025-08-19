{
  config,
  homeDirectory,
  pkgs,
  username,
  ...
}:

{
  imports = [
    ./modules/neovim.nix
  ];

  home.username = username;
  home.homeDirectory = homeDirectory;

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "24.05";

  home.packages = with pkgs; [
    atuin
    bats
    cargo
    comma
    # WARN: Not supported by darwin
    # dagger
    delta
    docker-credential-helpers
    expect
    file
    fluxcd
    fzf
    gh
    gh-copilot
    gh-dash
    gh-markdown-preview
    git
    glow
    gnused
    go
    gotop
    gitmux
    gnumake
    htop
    hyperfine
    kind
    k9s
    krew
    kubectl
    kubectl-validate
    (wrapHelm kubernetes-helm {
      plugins = [
        kubernetes-helmPlugins.helm-diff
      ];
    })
    kubeseal
    kubeswitch
    lazygit
    lnav
    navi
    ncurses
    nix-init
    nodejs
    pigz
    pluto
    podman
    python3
    ripgrep
    skopeo
    tlrc # tldr (Rust)
    tmux
    tree
    trivy
    unzip
    update-nix-fetchgit
    uutils-coreutils-noprefix
    viddy
    wget
    xclip
    xsel
    xdg-utils
    yank
    yq-go
    zoxide
  ];

  home.file =
    let
      dotfilesHome = "${config.home.homeDirectory}/Repositories/GitHub/dotfiles/home/nixos";
    in
    {
      # WARN: Conflicts with podman
      # ".config/containers/registries.conf" = {
      #   source = config.lib.file.mkOutOfStoreSymlink "${dotfilesHome}/.config/containers/registries.conf";
      # };
      ".config/home-manager" = {
        recursive = true;
        source = config.lib.file.mkOutOfStoreSymlink "${dotfilesHome}/.config/home-manager";
      };
      ".config/kitty" = {
        recursive = true;
        source = config.lib.file.mkOutOfStoreSymlink "${dotfilesHome}/.config/kitty";
      };
      ".config/lazygit" = {
        recursive = true;
        source = config.lib.file.mkOutOfStoreSymlink "${dotfilesHome}/.config/lazygit";
      };
      ".config/navi" = {
        recursive = true;
        source = config.lib.file.mkOutOfStoreSymlink "${dotfilesHome}/.config/navi";
      };
      ".config/nvimpager" = {
        recursive = true;
        source = config.lib.file.mkOutOfStoreSymlink "${dotfilesHome}/.config/nvimpager";
      };
      ".config/tmux" = {
        recursive = true;
        source = config.lib.file.mkOutOfStoreSymlink "${dotfilesHome}/.config/tmux";
      };
      ".bash_aliases" = {
        source = config.lib.file.mkOutOfStoreSymlink "${dotfilesHome}/.bash_aliases";
      };
      ".bashrc_extra" = {
        source = config.lib.file.mkOutOfStoreSymlink "${dotfilesHome}/.bashrc";
      };
      ".gitconfig" = {
        source = config.lib.file.mkOutOfStoreSymlink "${dotfilesHome}/.gitconfig";
      };
      ".inputrc" = {
        source = config.lib.file.mkOutOfStoreSymlink "${dotfilesHome}/.inputrc";
      };
      "bin" = {
        recursive = true;
        source = config.lib.file.mkOutOfStoreSymlink "${dotfilesHome}/bin";
      };
    };

  nix = {
    package = pkgs.nixVersions.latest;

    settings.experimental-features = [
      "flakes"
      "nix-command"
    ];
  };

  nixpkgs.config = {
    allowUnfree = true;
  };

  programs.home-manager.enable = true;

  programs.bash = {
    enable = true;
    bashrcExtra = ''
      . ~/.bashrc_extra
    '';
  };

  programs.nix-index.enable = true;
}
