{
  pkgs,
  ...
}:

{
  home.packages = with pkgs; [
    antigravity-cli
    python313Packages.universal-silabs-flasher
  ];
}
