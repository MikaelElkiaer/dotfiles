{
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "docker-credential-ghcr-login";
  version = "unstable-2025-12-04";

  src = fetchFromGitHub {
    owner = "mikaelelkiaer";
    repo = "docker-credential-ghcr-login";
    rev = "f850028b4ed00a2964c86896042dc0f06e4797f2"; # main
    sha256 = "1q6mg62h8ayasj0dy2a1x4psnmbs67wkhnbmzqf9qpaykw08yrrm";
  };

  vendorHash = "sha256-+sedmiB1v5WMc+hOZyWBBU5nN7mlP2HTJL2qWqeb/jM=";

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
