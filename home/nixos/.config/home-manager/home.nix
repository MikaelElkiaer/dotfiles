{
  config,
  pkgs,
  inputs,
  username,
  homeDirectory,
  ...
}:

let
  dagger = inputs.dagger.packages.${pkgs.system}.dagger;
  docker-credential-magic = (pkgs.callPackage ./packages/docker-credential-magic.nix { });
  docker-credential-ghcr-login = (pkgs.callPackage ./packages/docker-credential-ghcr-login.nix { });
  dotnet = (
    with pkgs.dotnetCorePackages;
    combinePackages [
      sdk_9_0
      sdk_8_0_3xx
    ]
  );
in
{
  imports = [ ./neovim.nix ];

  home.username = username;
  home.homeDirectory = homeDirectory;

  home.stateVersion = "24.05"; # WARN: Do not change

  home.packages = with pkgs; [
    amazon-ecr-credential-helper
    atuin
    awscli2
    bats
    bws
    cargo
    dagger
    delta
    dotnet
    docker-credential-ghcr-login
    docker-credential-helpers
    docker-credential-magic
    file
    fluxcd
    fzf
    gh
    gh-copilot
    gh-dash
    gh-markdown-preview
    git
    glow
    go
    gotop
    gitmux
    gnumake
    htop
    hyperfine
    k9s
    kubectl
    kubernetes-helm
    kubeseal
    kubeswitch
    lazydocker
    lazygit
    lnav
    navi
    ncurses
    nodejs
    pigz
    python3
    renovate
    ripgrep
    skopeo
    tmux
    tree
    trivy
    unzip
    vault-bin
    wget
    xclip
    xsel
    xdg-utils
    yq-go
    zoxide
  ];

  home.file =
    let
      dotfilesHome = "${config.home.homeDirectory}/Repositories/GitHub/dotfiles/home/nixos";
    in
    {
      ".config/containers/registries.conf" = {
        source = config.lib.file.mkOutOfStoreSymlink "${dotfilesHome}/.config/containers/registries.conf";
      };
      ".config/home-manager" = {
        recursive = true;
        source = config.lib.file.mkOutOfStoreSymlink "${dotfilesHome}/.config/home-manager";
      };
      ".config/lazygit" = {
        recursive = true;
        source = config.lib.file.mkOutOfStoreSymlink "${dotfilesHome}/.config/lazygit";
      };
      ".config/navi" = {
        recursive = true;
        source = config.lib.file.mkOutOfStoreSymlink "${dotfilesHome}/.config/navi";
      };
      ".config/tmux" = {
        recursive = true;
        source = config.lib.file.mkOutOfStoreSymlink "${dotfilesHome}/.config/tmux";
      };
      ".docker/config.json" = {
        source = config.lib.file.mkOutOfStoreSymlink "${dotfilesHome}/.docker/config.json";
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

  home.sessionVariables = { };

  nix = {
    package = pkgs.nixVersions.git;

    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  nixpkgs.config = {
    allowUnfree = true;
    # WARN: Need to permit these in order to use dotnetCorePackages
    # - even to install newer SDKs
    permittedInsecurePackages = [
      "dotnet-core-combined"
      "dotnet-sdk-6.0.428"
      "dotnet-sdk-7.0.410"
      "dotnet-sdk-wrapped-6.0.428"
    ];
  };

  programs.home-manager.enable = true;

  programs.bash = {
    enable = true;
    bashrcExtra = ''
      . ~/.bashrc_extra
    '';
  };
  programs.gpg.enable = true;
  services.gpg-agent.enable = true;
  services.ssh-agent.enable = true;
}
