{
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "docker-credential-ghcr-login";
  version = "unstable-2025-05-30";

  src = fetchFromGitHub {
    owner = "mikaelelkiaer";
    repo = "docker-credential-ghcr-login";
    rev = "14bd0975d55d9aa43b24f66a85f747d0466828c2"; # main
    sha256 = "1cc5di3msgwjdh3rin3kfcl8w08282rssanf5m90r27x30cn66rd";
  };

  vendorHash = "sha256-z60OgpWuVcZplSvOAwxqB/S6DT6kh3mNUdYrLHArpOg=";

  ldflags = [
    "-s"
    "-w"
    "-X main.VERSION=${version}"
  ];

  meta = {
    description = "Automagically auth to GitHub Container Registry via docker credential helper";
    mainProgram = "docker-credential-ghcr-login";
    homepage = "https://github.com/mikaelelkiaer/docker-credential-ghcr-login";
  };
}
