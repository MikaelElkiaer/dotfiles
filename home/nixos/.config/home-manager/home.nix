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
    tlrc
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
      "flakes"
      "nix-command"
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

  systemd.user.services = {
    gh-notification-counter = {
      Install = {
        WantedBy = [ "default.target" ];
      };
      Service = {
        ExecStart = "${pkgs.writeShellScript "gh-notification-counter" ''
          set -Eeuo pipefail

          if ! command -v gh > /dev/null || ! gh auth status --active | grep '\- Token scopes:' | grep --silent "'notifications'"; then
            echo "Ensure gh is installed, authenticated, and has scope 'notifications'" >&2
            echo "Clearing state" >&2
            rm --force "$HOME/.local/state/gh-notification-counter"
            exit 0
          fi

          gh api graphql \
            --field=query='query { viewer { notificationThreads(query: "is:unread") { totalCount } } }' \
            --jq=".data.viewer.notificationThreads.totalCount" >"$HOME/.local/state/gh-notification-counter"
        ''}";
      };
      Unit = {
        Description = "Count GitHub notifications";
      };
    };
    login-status-aws = {
      Install = {
        WantedBy = [ "default.target" ];
      };
      Service = {
        ExecStart = "${pkgs.writeShellScript "login-status-aws" ''
          set -Eeuo pipefail

          if ! command -v aws > /dev/null; then
            echo "Ensure aws is installed" >&2
            echo "Clearing state" >&2
            rm --force "$HOME/.local/state/login-status-aws"
            exit 0
          fi

          (aws sts get-caller-identity >&2; echo $?) >"$HOME/.local/state/login-status-aws"
        ''}";
      };
      Unit = {
        Description = "Set login status for AWS";
      };
    };
    login-status-vault = {
      Install = {
        WantedBy = [ "default.target" ];
      };
      Service = {
        ExecStart = "${pkgs.writeShellScript "login-status-vault" ''
          set -Eeuo pipefail

          # Load additional profiles
          for f in $(find ~ -maxdepth 1 -name '.bash_profile_*'); do
            source "$f"
          done

          if ! command -v vault > /dev/null || [ -z "$VAULT_ADDR" ]; then
            echo "Ensure vault is installed and VAULT_ADDR is set" >&2
            echo "Clearing state" >&2
            rm --force "$HOME/.local/state/login-status-vault"
            exit 0
          fi

          export VAULT_ADDR
          (vault token lookup >&2; echo $?) >"$HOME/.local/state/login-status-vault"
        ''}";
      };
      Unit = {
        Description = "Set login status for Vault";
      };
    };
  };

  systemd.user.timers = {
    gh-notification-counter = {
      Install = {
        WantedBy = [ "timers.target" ];
      };
      Timer = {
        OnCalendar = "*-*-* *:*:00";
        Persistent = true;
      };
      Unit = {
        Description = "Count GitHub notifications every minute";
      };
    };
    login-status-aws = {
      Install = {
        WantedBy = [ "timers.target" ];
      };
      Timer = {
        OnCalendar = "*-*-* *:*:00";
        Persistent = true;
      };
      Unit = {
        Description = "Run login status for AWS every minute";
      };
    };
    login-status-vault = {
      Install = {
        WantedBy = [ "timers.target" ];
      };
      Timer = {
        OnCalendar = "*-*-* *:*:00";
        Persistent = true;
      };
      Unit = {
        Description = "Run login status for Vault every minute";
      };
    };
  };
}
