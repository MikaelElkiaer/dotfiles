# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL

{
  pkgs,
  ...
}:

{
  # WSL module is now handled via flake.nix
  # imports = [ <nixos-wsl/modules> ];

  environment.systemPackages = with pkgs; [ home-manager ];

  # INFO: Should be set by wsl module, but is deprecated
  # - see https://github.com/nix-community/NixOS-WSL/issues/498
  hardware.graphics.enable = true;

  # NOTE: Absolute paths like /etc/nixos/certs may require --impure flag during evaluation
  # or should be moved into the flake and referenced with relative paths.
  security.pki.certificateFiles =
    let
      certsDir = ./certs;
    in
    if builtins.pathExists certsDir then
      builtins.map (x: certsDir + ("/" + x)) (builtins.attrNames (builtins.readDir certsDir))
    else [ ];

  users.users.nixos.extraGroups = [ "docker" ];

  virtualisation.docker = {
    enable = true;
  };

  wsl.enable = true;
  wsl.defaultUser = "nixos";

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "26.05"; # Did you read the comment?
}


