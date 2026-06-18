{
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "docker-credential-ghcr-login";
  version = "unstable-2026-06-15";

  src = fetchFromGitHub {
    owner = "mikaelelkiaer";
    repo = "docker-credential-ghcr-login";
    rev = "8912eb508338a12c0f785b093396efce02cbb8d3"; # main
    sha256 = "1arrzji05ks43896ga4a7yif6iffh56dy5js4iddn2p9qvi5cclq";
  };

  vendorHash = "sha256-n8PQv0IKcu+F16Opq6w9O5jew17YATufZPaFh2ZMbnM=";

  ldflags = [
    "-w"
    "-X main.VERSION=${version}"
  ];

  meta = {
    description = "Automagically auth to GitHub Container Registry via docker credential helper";
    mainProgram = "docker-credential-ghcr-login";
    homepage = "https://github.com/mikaelelkiaer/docker-credential-ghcr-login";
  };
}
