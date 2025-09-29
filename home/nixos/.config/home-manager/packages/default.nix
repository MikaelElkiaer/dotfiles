# ```
# # ~/.config/nix-init/config.toml
# [access-tokens]
# "github.com".command = ["gh", "auth", "token"]
# ```
# NIX_CONFIG="access-tokens = github.com=$(gh auth token)" nix-init
{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "conductor";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "containdk";
    repo = "conductor";
    rev = "v${version}";
    hash = "sha256-aK6GTNQWqouR/vN7hgxq4uSHMfA4k8F/430oS7+TZe4=";
  };

  vendorHash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${version}"
  ];

  meta = {
    description = "Conductor the distribution manager for rollout";
    homepage = "https://github.com/containdk/conductor";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "conductor";
  };
}
