{
  pkgs,
  ...
}:

{
  home.packages = with pkgs; [
    ic
    kubelogin-oidc
    lastpass-cli
  ];
}
