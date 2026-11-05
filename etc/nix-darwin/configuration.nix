{
  ...
}:
{
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = [
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
      "lastpass-cli"
      "pint"
      "tinyproxy"
      "tree-sitter-cli"
    ];
    casks = [
      "1password-cli"
      "alfred"
      "bettershot"
      "caffeine"
      "font-noto-nerd-font"
      "font-noto-sans-mono"
      "kitty"
      "podman-desktop"
    ];
    extraConfig = ''
      # INFO: Manage some homebrew outside nix-darwin, e.g.:
      # ```ruby
      # tap some-owner/some-repo, trusted: true
      # brew some-owner/some-repo/some-brew, trusted: true
      # ```
      local_brewfile = File.expand_path("~/.Brewfile.local")
      instance_eval(File.read(local_brewfile)) if File.exist?(local_brewfile)
    '';
    # Delete undeclared brews and casks
    onActivation.cleanup = "zap";
    taps = [
      {
        name = "chainguard-dev/tap";
        trusted = true;
      }
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
  #

  # FIXME: 2026-07-05 Temporary work-around for nix-darwing build
  # failure on nixpkgs-unstable
  #
  # https://github.com/nix-darwin/nix-darwin/issues/1817
  #
  documentation.enable = false;
  system.tools.darwin-uninstaller.enable = false;
}
