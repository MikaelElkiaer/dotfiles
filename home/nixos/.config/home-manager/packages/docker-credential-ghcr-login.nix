{
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "docker-credential-ghcr-login";
  version = "unstable-2025-03-06";

  src = fetchFromGitHub {
    owner = "mikaelelkiaer";
    repo = "docker-credential-ghcr-login";
    rev = "4d96cc39b5abe0fa9124644754c4a3d57680ffd4"; # main
    sha256 = "14bwyjpiv64lmf333p0svayzsj8lf34xlfrwaamw27l5ppr4j5qn";
  };

  vendorHash = "sha256-1dyi9FH218O0o+BNMfY84Wal2edCrUiqfk/OocSSGso=";

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
