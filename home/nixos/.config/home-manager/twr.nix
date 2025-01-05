{
  pkgs,
  ...
}:

{
  home.packages = with pkgs; [
    python313Packages.universal-silabs-flasher
  ];
}
