{
  description = "Example nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      nixpkgs,
    }:
    let
      configuration =
        { pkgs, ... }:
        {
          # List packages installed in system profile. To search by name, run:
          # $ nix-env -qaP | grep wget
          environment.systemPackages = with pkgs; [
            # WARN: Desktop applications installed this way will not appear in Spotlight
            # - see https://github.com/nix-darwin/nix-darwin/issues/1576
            # - use `homebrew.casks` instead
          ];

          # Manage Homebrew
          # - needs to be installed manually
          # - e.g. `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`
          homebrew = {
            enable = true;
            brews = [
              "lastpass-cli"
              "pint"
              "tinyproxy"
            ];
            casks = [
              "1password-cli"
              "alfred"
              "caffeine"
              "font-hack-nerd-font" # Needed for sketchybar
              "font-noto-sans-mono"
              "font-sketchybar-app-font" # Needed for sketchybar
              "kitty"
              "podman-desktop"
              "trex"
            ];
            # Delete undeclared brews and casks
            onActivation.cleanup = "zap";
          };

          # Necessary for using flakes on this system.
          nix.settings.experimental-features = "nix-command flakes";

          # Enable finger print for sudo
          security.pam.services.sudo_local.enable = true;
          security.pam.services.sudo_local.reattach = true;
          security.pam.services.sudo_local.touchIdAuth = true;

          services.aerospace.enable = true;
          services.aerospace.settings =
            let
              toml = builtins.fromTOML (builtins.readFile ./aerospace.toml);
            in
            toml // {
              on-mode-changed = [
                "exec-and-forget ${pkgs.sketchybar}/bin/sketchybar --trigger aerospace_mode_change"
              ];
              exec-on-workspace-change = [
                "exec-and-forget ${pkgs.sketchybar}/bin/sketchybar --trigger aerospace_workspace_change FOCUSED_WORKSPACE=$AEROSPACE_FOCUSED_WORKSPACE PREV_WORKSPACE=$AEROSPACE_PREV_WORKSPACE"
              ];
            };

          services.sketchybar.enable = true;
          services.sketchybar.config = builtins.readFile ./sketchybarrc;
          services.sketchybar.extraPackages = [ pkgs.jq ];

          # Enable alternative shell support in nix-darwin.
          # programs.fish.enable = true;

          # Set Git commit hash for darwin-version.
          system.configurationRevision = self.rev or self.dirtyRev or null;

          system.defaults.dock.autohide = true;
          system.defaults.NSGlobalDomain._HIHideMenuBar = true;

          system.primaryUser = "mae";

          # Used for backwards compatibility, please read the changelog before changing.
          # $ darwin-rebuild changelog
          system.stateVersion = 6;

          # The platform the configuration will be used on.
          nixpkgs.hostPlatform = "aarch64-darwin";
        };
    in
    {
      darwinConfigurations."mae-mac-G00T0L7FPY" = nix-darwin.lib.darwinSystem {
        modules = [ configuration ];
      };
    };
}
