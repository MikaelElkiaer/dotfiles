{
  description = "Unified dotfiles configuration";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs_master.url = "github:nixos/nixpkgs/master";
    nixpkgs_stable.url = "github:nixos/nixpkgs/release-25.11";
    nixpkgs_gemini.url = "github:nixos/nixpkgs/4f00b3a049e6a95ab14ec8e0a163c631a7216833";

    # Darwin
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Home Manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # NixOS WSL
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Others
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
      self,
      nixpkgs,
      nixpkgs_master,
      nixpkgs_stable,
      nixpkgs_gemini,
      nix-darwin,
      home-manager,
      nix-index-database,
      dagger,
      ...
    }:
    let
      hosts = {
        "mae-mac-G00T0L7FPY" = {
          system = "aarch64-darwin";
          username = "mae";
          homeDirectory = "/Users/mae";
          isDarwin = true;
          isNixOS = false;
        };
        "twr" = {
          system = "x86_64-linux";
          username = "me";
          homeDirectory = "/home/me";
          isDarwin = false;
          isNixOS = false;
        };
        "nixos" = {
          system = "x86_64-linux";
          username = "nixos";
          homeDirectory = "/home/nixos";
          isDarwin = false;
          isNixOS = true;
        };
      };

      # Path to home-manager base directory
      hmDir = ./home/nixos/.config/home-manager;

      localPackages =
        let
          files = builtins.readDir (hmDir + "/packages");
          names = builtins.attrNames (
            nixpkgs.lib.filterAttrs (n: v: v == "regular" && nixpkgs.lib.hasSuffix ".nix" n) files
          );
        in
        map (n: nixpkgs.lib.removeSuffix ".nix" n) names;

      customPackages =
        final: prev:
        let
          localPkgs = nixpkgs.lib.genAttrs localPackages (
            name: prev.callPackage (hmDir + "/packages/${name}.nix") { }
          );
        in
        localPkgs
        // {
          dagger = inputs.dagger.packages.${prev.system}.dagger;
          diffyml = (
            let
              pkgs = import nixpkgs_stable { system = prev.system; };
            in
            pkgs.callPackage (hmDir + "/packages/diffyml.nix") {
              inherit (pkgs)
                lib
                fetchFromGitHub
                ;
              buildGoModule = pkgs.buildGoModule.override { go = pkgs.go_1_26; };
            }
          );
        };

      # Helper for standalone Home Manager configuration
      mkHomeConfig =
        host: info:
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${info.system}.extend customPackages;
          modules = [
            {
              nixpkgs.config.allowUnfree = true;
            }
            nix-index-database.homeModules.nix-index
            (hmDir + "/home.nix")
            (
              let
                f = hmDir + "/hosts/${host}.nix";
              in
              if builtins.pathExists f then f else { }
            )
            {
              _module.args = {
                inherit (info) username homeDirectory;
              };
            }
          ];
        };

      # Helper for NixOS configuration (with integrated Home Manager)
      mkNixosConfig =
        host: info:
        nixpkgs.lib.nixosSystem {
          inherit (info) system;
          modules = [
            # Main NixOS configuration
            ./etc/nixos/configuration.nix
            # NixOS-WSL module
            inputs.nixos-wsl.nixosModules.default
            # Integrate Home Manager
            home-manager.nixosModules.home-manager
            {
              nixpkgs.config.allowUnfree = true;
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = false;
              home-manager.users.${info.username} = {
                imports = [
                  (hmDir + "/home.nix")
                  (
                    let
                      f = hmDir + "/hosts/${host}.nix";
                    in
                    if builtins.pathExists f then f else { }
                  )
                  nix-index-database.homeModules.nix-index
                ];
              };
              home-manager.extraSpecialArgs = {
                inherit (info) username homeDirectory;
                inherit inputs;
              };
            }
            # Add custom packages to nixpkgs
            {
              nixpkgs.overlays = [ customPackages ];
            }
          ];
          specialArgs = {
            inherit host info inputs;
          };
        };

      # Helper for nix-darwin configuration (with integrated Home Manager)
      mkDarwinConfig =
        host: info:
        nix-darwin.lib.darwinSystem {
          system = info.system;
          modules = [
            # Main darwin configuration
            ./etc/nix-darwin/configuration.nix
            {
              nixpkgs.hostPlatform = info.system;
              nixpkgs.config.allowUnfree = true;
              system.configurationRevision = self.rev or self.dirtyRev or null;
            }
            # Define the user for nix-darwin & home-manager
            {
              users.users.${info.username} = {
                name = info.username;
                home = info.homeDirectory;
              };
            }
            # Integrate Home Manager
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = false;
              home-manager.users.${info.username} = {
                imports = [
                  (hmDir + "/home.nix")
                  (
                    let
                      f = hmDir + "/hosts/${host}.nix";
                    in
                    if builtins.pathExists f then f else { }
                  )
                  nix-index-database.homeModules.nix-index
                ];
              };
              home-manager.extraSpecialArgs = {
                inherit (info) username homeDirectory;
                inherit inputs;
              };
            }
            # Add custom packages to nix-darwin's nixpkgs
            {
              nixpkgs.overlays = [ customPackages ];
            }
          ];
          specialArgs = {
            inherit host info inputs;
          };
        };

      systems = nixpkgs.lib.unique (map (h: h.system) (builtins.attrValues hosts));
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {
      # Standalone home-manager configurations
      # Usage: home-manager switch --flake .#user@host
      homeConfigurations = nixpkgs.lib.mapAttrs' (host: info: {
        name = "${info.username}@${host}";
        value = mkHomeConfig host info;
      }) hosts;

      # Darwin configurations
      # Usage: darwin-rebuild switch --flake .#host
      darwinConfigurations = nixpkgs.lib.mapAttrs (host: info: mkDarwinConfig host info) (
        nixpkgs.lib.filterAttrs (host: info: info.isDarwin) hosts
      );

      # NixOS configurations
      # Usage: nixos-rebuild switch --flake .#host
      nixosConfigurations = nixpkgs.lib.mapAttrs (host: info: mkNixosConfig host info) (
        nixpkgs.lib.filterAttrs (host: info: info.isNixOS) hosts
      );

      # Expose packages
      packages = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system}.extend customPackages;
        in
        nixpkgs.lib.genAttrs ([ "dagger" ] ++ localPackages) (name: pkgs.${name})
      );
    };
}
