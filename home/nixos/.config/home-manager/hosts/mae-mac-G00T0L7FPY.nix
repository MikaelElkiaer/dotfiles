{
  pkgs,
  ...
}:

{
  home.packages = with pkgs; [
    kubelogin-oidc
    lastpass-cli
  ];
}
