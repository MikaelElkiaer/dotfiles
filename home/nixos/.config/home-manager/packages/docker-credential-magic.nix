{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "docker-credential-magic";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "docker-credential-magic";
    repo = "docker-credential-magic";
    rev = "v${version}";
    sha256 = "sha256-Jr1NGAwPAaNMOSwsBXETO9wWQNoncJ0hQnzsktentSQ=";
  };

  vendorHash = "sha256-GZl81pidLU/sA4pf7QeXuszFkj50+31kLrsZ+SN3vf8=";

  subPackages = [ "cmd/docker-credential-magic" ];

  ldflags = [
    "-s"
    "-w"
    "-X main.VERSION=${version}"
  ];

  preBuild = ''
    cp -r mappings internal/embedded/mappings/embedded
  '';

  meta = with lib; {
    description = "A magic shim for Docker credential helpers";
    mainProgram = "docker-credential-magic";
    homepage = "https://github.com/docker-credential-magic/docker-credential-magic";
    changelog = "https://github.com/docker-credential-magic/docker-credential-magic/releases/tag/v${version}";
    license = licenses.asl20;
  };
}
