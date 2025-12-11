{
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "docker-credential-ghcr-login";
  version = "unstable-2025-12-11";

  src = fetchFromGitHub {
    owner = "mikaelelkiaer";
    repo = "docker-credential-ghcr-login";
    rev = "ed98a2dbfeb916380c06e112c096940aab3d18d0"; # main
    sha256 = "1nzc212rjr5k1dkaz7js24d4n8hr7scp3rfh5509m2nncy98ma71";
  };

  vendorHash = "sha256-fsQbn3/JmVeRFD+Pxm+FV7t1fY4zak3BLXtAM1EcLMk=";

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
