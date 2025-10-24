{
  description = "Home Manager configuration of nixos";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs_stable.url = "github:nixos/nixpkgs/release-25.05";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dagger = {
      url = "github:dagger/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      nixpkgs,
      nixpkgs_stable,
      nix-index-database,
      home-manager,
      dagger,
      ...
    }:
    let
      customPackages = final: prev: {
        dagger = inputs.dagger.packages.${prev.system}.dagger;
        docker-credential-magic = (prev.callPackage ./packages/docker-credential-magic.nix { });
        docker-credential-ghcr-login = (prev.callPackage ./packages/docker-credential-ghcr-login.nix { });
        ic = (prev.callPackage ./packages/ic.nix { });
        kubelogin = (import nixpkgs_stable { system = prev.system; }).kubelogin;
      };
    in
    {
      # macOS 15
      homeConfigurations."mae@mae-mac-G00T0L7FPY" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.aarch64-darwin.extend customPackages;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [
          nix-index-database.homeModules.nix-index
          ./home.nix
          ./hosts/mae-mac-G00T0L7FPY.nix
          # Optionally use extraSpecialArgs
          # to pass through arguments to home.nix
          {
            _module.args = {
              username = "mae";
              homeDirectory = "/Users/mae";
            };
          }
        ];
      };
      # Debian 12
      homeConfigurations."me@twr" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux.extend customPackages;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [
          nix-index-database.homeModules.nix-index
          ./home.nix
          ./hosts/twr.nix
          # Optionally use extraSpecialArgs
          # to pass through arguments to home.nix
          {
            _module.args = {
              username = "me";
              homeDirectory = "/home/me";
            };
          }
        ];
      };
    };
}
