{
  pkgs,
  ...
}:

{
  home.packages = with pkgs; [
    awscli2
    ic
    kubelogin-oidc
    lastpass-cli
  ];
}
