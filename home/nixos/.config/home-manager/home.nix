{
  config,
  pkgs,
  username,
  homeDirectory,
  ...
}:

let
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
    go
    gotop
    gitmux
    gnumake
    htop
    hyperfine
    kind
    k9s
    kubectl
    kubectl-validate
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
    pluto
    python3
    renovate
    ripgrep
    skopeo
    tlrc
    tmux
    tree
    trivy
    unzip
    vault-bin
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
      ".config/nvimpager" = {
        recursive = true;
        source = config.lib.file.mkOutOfStoreSymlink "${dotfilesHome}/.config/nvimpager";
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

  systemd.user = {
    services = {
      gh-notifications-counter = {
        Install.WantedBy = [ "default.target" ];
        Service.ExecStart = "${config.home.homeDirectory}/bin/gh-notifications-counter";
        Unit.Description = "Count GitHub notifications";
      };
      login-status-aws = {
        Install.WantedBy = [ "default.target" ];
        Service.ExecStart = "${config.home.homeDirectory}/bin/login-status-aws";
        Unit.Description = "Set login status for AWS";
      };
      login-status-gkd = {
        Install.WantedBy = [ "default.target" ];
        Service.ExecStart = "${config.home.homeDirectory}/bin/login-status-gkd";
        Unit.Description = "Set login status for gnome-keyring-daemon";
      };
      login-status-vlt = {
        Install.WantedBy = [ "default.target" ];
        Service.ExecStart = "${config.home.homeDirectory}/bin/login-status-vlt";
        Unit.Description = "Set login status for Vault";
      };
      upgrade-status-apt = {
        Install.WantedBy = [ "default.target" ];
        Service.ExecStart = "${config.home.homeDirectory}/bin/upgrade-status-apt";
        Unit.Description = "Set upgrade status for apt";
      };
      upgrade-status-hm = {
        Install.WantedBy = [ "default.target" ];
        Service.ExecStart = "${config.home.homeDirectory}/bin/upgrade-status-hm";
        Unit.Description = "Set upgrade status for Home Manager";
      };
      upgrade-status-nvim = {
        Install.WantedBy = [ "default.target" ];
        Service.ExecStart = "${config.home.homeDirectory}/bin/upgrade-status-nvim";
        Unit.Description = "Set upgrade status for Neovim";
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
      login-status-aws = {
        Install.WantedBy = [ "timers.target" ];
        Timer = {
          OnCalendar = "*-*-* *:*:00";
          Persistent = true;
        };
        Unit.Description = "Run login status for AWS every minute";
      };
      login-status-gkd = {
        Install.WantedBy = [ "timers.target" ];
        Timer = {
          OnCalendar = "*-*-* *:*:00";
          Persistent = true;
        };
        Unit.Description = "Run login status for keyring every minute";
      };
      login-status-vlt = {
        Install.WantedBy = [ "timers.target" ];
        Timer = {
          OnCalendar = "*-*-* *:*:00";
          Persistent = true;
        };
        Unit.Description = "Run login status for Vault every minute";
      };
      upgrade-status-apt = {
        Install.WantedBy = [ "timers.target" ];
        Timer = {
          OnCalendar = "*-*-* *:0/10:00";
          Persistent = true;
        };
        Unit.Description = "Run upgrade status for apt every 10 minutes";
      };
      upgrade-status-hm = {
        Install.WantedBy = [ "timers.target" ];
        Timer = {
          OnCalendar = "*-*-* *:0/10:00";
          Persistent = true;
        };
        Unit.Description = "Run upgrade status for Home Manager every 10 minutes";
      };
      upgrade-status-nvim = {
        Install.WantedBy = [ "timers.target" ];
        Timer = {
          OnCalendar = "*-*-* *:0/10:00";
          Persistent = true;
        };
        Unit.Description = "Run upgrade status for Neovim every 10 minutes";
      };
    };
  };
}
