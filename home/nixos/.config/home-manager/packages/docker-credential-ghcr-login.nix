{
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "docker-credential-ghcr-login";
  version = "unstable-2026-05-26";

  src = fetchFromGitHub {
    owner = "mikaelelkiaer";
    repo = "docker-credential-ghcr-login";
    rev = "75da140761b7de39dfad8161e0d3ab4e62f701be"; # main
    sha256 = "1vi7sk5cckr2vlm4kwalxa0gf47hk2y1dfkgi55h0kwgsf1bvanx";
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
