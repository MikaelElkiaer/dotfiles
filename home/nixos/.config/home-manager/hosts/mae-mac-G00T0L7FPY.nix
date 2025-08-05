{
  pkgs,
  ...
}:

{
  home.packages = with pkgs; [
    lastpass-cli
  ];
}
