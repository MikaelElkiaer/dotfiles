{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    docker-credential-ghcr-login
    docker-credential-magic
  ];
}
