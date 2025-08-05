{
  description = "Home Manager configuration of nixos";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
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
    nixgl = {
      url = "github:nix-community/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      nixgl,
      nixpkgs,
      nix-index-database,
      home-manager,
      dagger,
      ...
    }:
    let
      customPackages = final: prev: {
        dagger = inputs.dagger.packages.${pkgs.system}.dagger;
        docker-credential-magic = (pkgs.callPackage ./packages/docker-credential-magic.nix { });
        docker-credential-ghcr-login = (pkgs.callPackage ./packages/docker-credential-ghcr-login.nix { });
      };
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system}.extend customPackages;
    in
    {
      # macOS 15
      homeConfigurations."mae@mae-mac-G00T0L7FPY" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.aarch64-darwin;

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
        inherit pkgs;

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
      # Debian 12
      homeConfigurations."mikaelki@AD.KEYSIGHT.COM@czc2208rnd" =
        home-manager.lib.homeManagerConfiguration
          {
            inherit pkgs;

            # Specify your home configuration modules here, for example,
            # the path to your home.nix.
            modules = [
              nix-index-database.homeModules.nix-index
              ./home.nix
              ./hosts/czc2208rnd.nix
              # Optionally use extraSpecialArgs
              # to pass through arguments to home.nix
              {
                _module.args = {
                  username = "mikaelki@AD.KEYSIGHT.COM";
                  homeDirectory = "/home/mikaelki";
                  nixgl = nixgl;
                };
              }
            ];
          };
      # WSL2
      homeConfigurations."nixos@nixos" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [
          nix-index-database.homeModules.nix-index
          ./home.nix
          # Optionally use extraSpecialArgs
          # to pass through arguments to home.nix
          {
            _module.args = {
              username = "nixos";
              homeDirectory = "/home/nixos";
            };
          }
        ];
      };
    };
}
