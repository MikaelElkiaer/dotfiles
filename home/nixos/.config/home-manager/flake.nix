{
  description = "Home Manager configuration of nixos";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs_master.url = "github:nixos/nixpkgs/master";
    nixpkgs_stable.url = "github:nixos/nixpkgs/release-25.11";
    # INFO: Pre 0.17 - https://github.com/NixOS/nixpkgs/commit/af57e99c785f334638402ffd7b5e4565a0379461
    nixpkgs_gemini.url = "github:nixos/nixpkgs/af57e99c785f334638402ffd7b5e4565a0379461";
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
      nixpkgs_master,
      nixpkgs_stable,
      nixpkgs_gemini,
      nix-index-database,
      home-manager,
      dagger,
      ...
    }:
    let
      hosts = {
        "mae-mac-G00T0L7FPY" = {
          system = "aarch64-darwin";
          username = "mae";
          homeDirectory = "/Users/mae";
        };
        "twr" = {
          system = "x86_64-linux";
          username = "me";
          homeDirectory = "/home/me";
        };
      };

      systems = nixpkgs.lib.unique (map (h: h.system) (builtins.attrValues hosts));

      localPackages =
        let
          files = builtins.readDir ./packages;
          names = builtins.attrNames (
            nixpkgs.lib.filterAttrs (n: v: v == "regular" && nixpkgs.lib.hasSuffix ".nix" n) files
          );
        in
        map (n: nixpkgs.lib.removeSuffix ".nix" n) names;

      allPackageNames = [ "dagger" ] ++ localPackages;

      customPackages =
        final: prev:
        let
          localPkgs = nixpkgs.lib.genAttrs localPackages (
            name: prev.callPackage (./packages + "/${name}.nix") { }
          );
        in
        localPkgs
        // {
          dagger = inputs.dagger.packages.${prev.system}.dagger;
          diffyml = (
            let
              pkgs = import nixpkgs_stable { system = prev.system; };
            in
            pkgs.callPackage ./packages/diffyml.nix {
              inherit (pkgs)
                lib
                fetchFromGitHub
                ;
              buildGoModule = pkgs.buildGoModule.override { go = pkgs.go_1_26; };
            }
          );
        };

      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {
      packages = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system}.extend customPackages;
        in
        nixpkgs.lib.genAttrs allPackageNames (name: pkgs.${name})
      );

      homeConfigurations = nixpkgs.lib.mapAttrs' (host: info: {
        name = "${info.username}@${host}";
        value = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${info.system}.extend customPackages;
          modules = [
            nix-index-database.homeModules.nix-index
            ./home.nix
            (
              let
                f = ./hosts/${host}.nix;
              in
              if builtins.pathExists f then f else null
            )
            {
              _module.args = {
                inherit (info) username homeDirectory;
              };
            }
          ];
        };
      }) hosts;
    };
}
