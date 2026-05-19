{
  pkgs,
  host,
  ...
}:
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
      "chainguard-dev/tap/chainctl"
      # Needs to be fetched manually:
      # `HOMEBREW_GITHUB_API_TOKEN=$(gh auth token) brew fetch containdk/tap/beagle`
      "containdk/tap/beagle"
      # `HOMEBREW_GITHUB_API_TOKEN=$(gh auth token) brew fetch containdk/tap/conductor`
      "containdk/tap/conductor"
      # `HOMEBREW_GITHUB_API_TOKEN=$(gh auth token) brew fetch containdk/tap/solas`
      "containdk/tap/solas"
      "lastpass-cli"
      "pint"
      "tinyproxy"
      "tree-sitter-cli"
    ];
    casks = [
      "1password-cli"
      "alfred"
      "caffeine"
      "font-noto-nerd-font"
      "font-noto-sans-mono"
      "kitty"
      "podman-desktop"
      "trex"
    ];
    # Delete undeclared brews and casks
    onActivation.cleanup = "zap";
    taps = [
      "chainguard-dev/tap"
      "containdk/tap"
    ];
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
    toml;

  # Enable alternative shell support in nix-darwin.
  # programs.fish.enable = true;

  # Set Git commit hash for darwin-version.
  # system.configurationRevision = self.rev or self.dirtyRev or null; # Handled in flake.nix

  system.defaults.dock.autohide = true;
  system.defaults.NSGlobalDomain._HIHideMenuBar = true;

  system.primaryUser = "mae";

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;

  # The platform the configuration will be used on.
  # nixpkgs.hostPlatform = "aarch64-darwin"; # Handled in flake.nix
}
