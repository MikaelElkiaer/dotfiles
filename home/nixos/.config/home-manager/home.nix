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

  home.packages = with pkgs; [
    amazon-ecr-credential-helper
    atuin
    awscli2
    bats
    cargo
    inputs.dagger.packages.${system}.dagger
    delta
    (
      with dotnetCorePackages;
      combinePackages [
        sdk_9_0
        sdk_8_0_3xx
      ]
    )
    docker-credential-helpers
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
