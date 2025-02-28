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

          TMP="$(mktemp)"
          gh api graphql \
            --field=query='query { viewer { notificationThreads(query: "is:unread") { totalCount } } }' \
            --jq=".data.viewer.notificationThreads.totalCount" >"$TMP"
          mv "$TMP" "$HOME/.local/state/gh-notification-counter"
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
          if ! command -v aws > /dev/null; then
            echo "Ensure aws is installed" >&2
            echo "Clearing state" >&2
            rm --force "$HOME/.local/state/login-status-aws"
            exit 0
          fi

          TMP="$(mktemp)"
          (aws sts get-caller-identity >&2; echo $?) >"$TMP"
          mv "$TMP" "$HOME/.local/state/login-status-aws"
        ''}";
      };
      Unit = {
        Description = "Set login status for AWS";
      };
    };
    login-status-keyring = {
      Install = {
        WantedBy = [ "default.target" ];
      };
      Service = {
        ExecStart = "${pkgs.writeShellScript "login-status-keyring" ''
          # Dummy comment for syntax
          if ! command -v gnome-keyring-daemon > /dev/null; then
            echo "Ensure gnome-keyring-daemon is installed" >&2
            echo "Clearing state" >&2
            rm --force "$HOME/.local/state/login-status-gkd"
            exit 0
          fi

          TMP="$(mktemp)"
          IS_LOCKED="$(busctl --json=pretty --user get-property org.freedesktop.secrets /org/freedesktop/secrets/collection/login org.freedesktop.Secret.Collection Locked | jq '.data')"
          if [ "$IS_LOCKED" = "true" ]; then
            echo 1 >"$TMP"
          elif [ "$IS_LOCKED" = "false" ]; then
            echo 0 >"$TMP"
          fi
          mv "$TMP" "$HOME/.local/state/login-status-gkd"
        ''}";
      };
    };
    login-status-vault = {
      Install = {
        WantedBy = [ "default.target" ];
      };
      Service = {
        ExecStart = "${pkgs.writeShellScript "login-status-vlt" ''
          # Load additional profiles
          for f in $(find ~ -maxdepth 1 -name '.bash_profile_*'); do
            source "$f"
          done

          if ! command -v vault > /dev/null || [ -z "$VAULT_ADDR" ]; then
            echo "Ensure vault is installed and VAULT_ADDR is set" >&2
            echo "Clearing state" >&2
            rm --force "$HOME/.local/state/login-status-vlt"
            exit 0
          fi

          export VAULT_ADDR
          TMP="$(mktemp)"
          (vault token lookup >&2; echo $?) >"$TMP"
          mv "$TMP" "$HOME/.local/state/login-status-vlt"
        ''}";
      };
      Unit = {
        Description = "Set login status for Vault";
      };
    };
    upgrade-status-apt = {
      Install = {
        WantedBy = [ "default.target" ];
      };
      Service = {
        ExecStart = "${pkgs.writeShellScript "upgrade-status-apt" ''
          trap 'rm --force "$TMP"' EXIT

          if ! command -v apt &>/dev/null; then
            echo "Ensure apt is installed" >&2
            echo "Clearing state" >&2
            rm --force "$HOME/.local/state/upgrade-status-apt"
            exit 0
          fi

          TMP="$(mktemp)"
          apt list --upgradable | tail -n +2 >"$TMP"
          mv "$TMP" "$HOME/.local/state/upgrade-status-apt"
        ''}";
      };
      Unit = {
        Description = "Set upgrade status for apt";
      };
    };
    upgrade-status-hm = {
      Install = {
        WantedBy = [ "default.target" ];
      };
      Service = {
        ExecStart = "${pkgs.writeShellScript "upgrade-status-hm" ''
          set -Eeuo pipefail

          trap 'rm --force --recursive $TEMP' EXIT

          if ! command -v nix &>/dev/null; then
            echo "Ensure nix is installed" >&2
            echo "Clearing state" >&2
            rm --force "$HOME/.local/state/upgrade-status-hm"
            exit 0
          fi

          TEMP=$(mktemp --directory)
          cp --recursive $HOME/.config/home-manager/* "$TEMP"
          # shellcheck disable=SC2164
          cd "$TEMP"
          #TODO: Remove inputs (nixpkgs) once dagger is working again
          nix flake update --flake . nixpkgs
          home-manager build --flake .
          nix store diff-closures "$HOME/.local/state/nix/profiles/home-manager" ./result | sed -E '/[ε∅] → [ε∅]/d' >out
          mv out "$HOME/.local/state/upgrade-status-hm"
        ''}";
      };
      Unit = {
        Description = "Set upgrade status for Home Manager";
      };
    };
    upgrade-status-nvim = {
      Install = {
        WantedBy = [ "default.target" ];
      };
      Service = {
        ExecStart = "${pkgs.writeShellScript "upgrade-status-nvim" ''
          set -Eeuo pipefail

          trap 'rm --force $TEMP' EXIT

          if ! command -v nvim &>/dev/null; then
            echo "Ensure nvim is installed" >&2
            echo "Clearing state" >&2
            rm --force "$HOME/.local/state/upgrade-status-nvim"
            exit 0
          fi

          TEMP=$(mktemp)
          nvim --headless -c 'lua require("lazy").check({wait=true})' -c "qa" |
            # remove ansi escape codes
            sed --regexp-extended 's/\x1b\[[0-9;]*[a-zA-Z]//g' |
            # split lines
            sed --regexp-extended 's/(ago\))(\[)/\1\n\2/g' |
            # extract data
            sed --quiet --regexp-extended 's/\[([^ ]+)\] +log \| ([0-9a-f]{7,}) (.*)\(.* ago\)/\1\t\2\t\3/p' >"$TEMP"
          mv "$TEMP" "$HOME/.local/state/upgrade-status-nvim"
        ''}";
      };
      Unit = {
        Description = "Set upgrade status for Neovim";
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
    login-status-keyring = {
      Install = {
        WantedBy = [ "timers.target" ];
      };
      Timer = {
        OnCalendar = "*-*-* *:*:00";
        Persistent = true;
      };
      Unit = {
        Description = "Run login status for keyring every minute";
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
    upgrade-status-apt = {
      Install = {
        WantedBy = [ "timers.target" ];
      };
      Timer = {
        OnCalendar = "*-*-* *:0/10:00";
        Persistent = true;
      };
      Unit = {
        Description = "Run upgrade status for apt every 10 minutes";
      };
    };
    upgrade-status-hm = {
      Install = {
        WantedBy = [ "timers.target" ];
      };
      Timer = {
        OnCalendar = "*-*-* *:0/10:00";
        Persistent = true;
      };
      Unit = {
        Description = "Run upgrade status for Home Manager every 10 minutes";
      };
    };
    upgrade-status-nvim = {
      Install = {
        WantedBy = [ "timers.target" ];
      };
      Timer = {
        OnCalendar = "*-*-* *:0/10:00";
        Persistent = true;
      };
      Unit = {
        Description = "Run upgrade status for Neovim every 10 minutes";
      };
    };
  };
}
