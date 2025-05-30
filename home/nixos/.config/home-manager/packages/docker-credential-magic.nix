{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "docker-credential-magic";
  version = "unstable-2022-01-18";

  src = fetchFromGitHub {
    owner = "mikaelelkiaer";
    repo = "docker-credential-magic";
    rev = "d63a4c879cefd9cd24794e35265928816c7e21f3"; # main
    sha256 = "095mlzbr5v3w88hrsw17v901dp1v2dqhab1c756a608g1hc4vg96";
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
