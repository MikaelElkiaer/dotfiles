{
  pkgs,
  ...
}:

{
  home.packages = with pkgs; [
    dagger
    python313Packages.universal-silabs-flasher
  ];
}
