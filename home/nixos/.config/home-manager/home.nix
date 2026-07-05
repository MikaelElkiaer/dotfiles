{
  config,
  homeDirectory,
  lib,
  pkgs,
  username,
  ...
}:

{
  imports = [
    ./modules/neovim.nix
  ];

  home.username = lib.mkForce username;
  home.homeDirectory = lib.mkForce homeDirectory;

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
    bat
    bats
    cargo
    cloud-provider-kind
    comma
    github-copilot-cli
    dagger
    delta
    diffyml
    docker-credential-helpers
    entr
    expect
    fd
    file
    fluxcd
    flux-local
    fzf
    gemini-cli
    gh
    gh-dash
    gh-markdown-preview
    git
    glow
    gnused
    go
    golangci-lint
    gotop
    gitmux
    gnumake
    jsonnet
    jsonnet-bundler
    just
    jwt-cli
    htop
    hyperfine
    kind
    kustomize
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
    nix-prefetch-git
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
    util-linux # common unix utilities
    uutils-coreutils-noprefix
    uv
    velvet
    viddy
    yaml-schema-router
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
      # TODO: Turn into a module? Dynamically set 'credsStore' based on OS or other config
      ".config/containers/auth.json" = {
        source = config.lib.file.mkOutOfStoreSymlink "${dotfilesHome}/.config/containers/auth.json";
      };
      ".config/home-manager" = {
        recursive = true;
        source = config.lib.file.mkOutOfStoreSymlink "${dotfilesHome}/.config/home-manager";
      };
      ".config/kitty" = {
        recursive = true;
        source = config.lib.file.mkOutOfStoreSymlink "${dotfilesHome}/.config/kitty";
      };
      ".config/k9s" = {
        recursive = true;
        source = config.lib.file.mkOutOfStoreSymlink "${dotfilesHome}/.config/k9s";
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
      ".config/yamllint" = {
        recursive = true;
        source = config.lib.file.mkOutOfStoreSymlink "${dotfilesHome}/.config/yamllint";
      };
      ".bash_aliases" = {
        source = config.lib.file.mkOutOfStoreSymlink "${dotfilesHome}/.bash_aliases";
      };
      ".bashrc_extra" = {
        source = config.lib.file.mkOutOfStoreSymlink "${dotfilesHome}/.bashrc";
      };
      ".docker/config.json" = {
        source = config.lib.file.mkOutOfStoreSymlink "${dotfilesHome}/.config/containers/auth.json";
      };
      ".gemini/settings.json" = {
        source = config.lib.file.mkOutOfStoreSymlink "${dotfilesHome}/.gemini/settings.json";
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

  launchd.agents = {
    gh-notifications-counter = {
      config = {
        EnvironmentVariables = {
          PATH = "${
            lib.makeBinPath [
              pkgs.bash
              pkgs.gh
              pkgs.uutils-coreutils-noprefix
            ]
          }:/usr/local/bin:/usr/bin";
        };
        Program = "${config.home.homeDirectory}/bin/gh-notifications-counter";
        RunAtLoad = true;
        StartInterval = 60;
      };
      enable = true;
    };
  };

  nix = {
    package = lib.mkDefault pkgs.nixVersions.latest;

    settings.experimental-features = [
      "flakes"
      "nix-command"
    ];
  };

  programs.home-manager.enable = true;

  programs.bash = {
    enable = true;
    bashrcExtra = ''
      . ~/.bashrc_extra
    '';
  };

  programs.nix-index.enable = true;

  systemd.user = {
    services = {
      gh-notifications-counter = {
        Install.WantedBy = [ "default.target" ];
        Service = {
          Environment = [
            "PATH=${
              lib.makeBinPath [
                pkgs.bash
                pkgs.gh
              ]
            }:/usr/local/bin:/usr/bin"
          ];
          ExecStart = "${config.home.homeDirectory}/bin/gh-notifications-counter";
        };
        Unit.Description = "Count GitHub notifications";
      };
    };
    timers = {
      gh-notifications-counter = {
        Install.WantedBy = [ "timers.target" ];
        Timer = {
          OnCalendar = "*-*-* *:*:00";
          Persistent = true;
        };
        Unit.Description = "Count GitHub notifications every minute";
      };
    };
  };
}
