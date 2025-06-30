{
  pkgs,
  ...
}:

let
  dotnet = (
    with pkgs.dotnetCorePackages;
    combinePackages [
      dotnet_9.sdk
      dotnet_8.sdk
    ]
  );
in
{
  home.packages = [
    dotnet
  ];

  home.sessionVariables = {
    DOTNET_PATH = "${dotnet}/bin/dotnet";
    DOTNET_ROOT = "${dotnet}/share/dotnet";
  };
}
