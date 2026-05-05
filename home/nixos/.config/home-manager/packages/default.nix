# TODO: Test out
# - fix diffyml dependencies
# - ignore non-tagged packages
# for pkg in $(nix eval --impure --expr 'builtins.attrNames (import ./default.nix {})' --json | jq -r '.[]'); do
#   echo "Updating: $pkg"
#   nix run nixpkgs#nix-update -- --file default.nix "$pkg"
# done

{
  pkgs ? import <nixpkgs> { },
}:

let
  inherit (pkgs) lib callPackage;

  # 1. Read all files and directories in the current folder
  dirContents = builtins.readDir ./.;

  # 2. Filter out directories, non-nix files, and this default.nix file itself
  isPackageFile = name: type: type == "regular" && lib.hasSuffix ".nix" name && name != "default.nix";

  packageFiles = lib.filterAttrs isPackageFile dirContents;

  # 3. Map over the filtered files to build our final attribute set
  #    This turns "diffyml.nix" into the attribute name "diffyml"
  packages = lib.mapAttrs' (
    name: _: lib.nameValuePair (lib.removeSuffix ".nix" name) (callPackage (./. + "/${name}") { })
  ) packageFiles;

in
packages
