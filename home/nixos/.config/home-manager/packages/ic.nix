{
  lib,
  buildGo127Module,
  fetchFromGitHub,
}:

buildGo127Module rec {
  pname = "ic";
  version = "0.11.2";

  src = fetchFromGitHub {
    owner = "containdk";
    repo = "ic";
    tag = "v${version}";
    hash = "sha256-rYzypU6VtGJTBrfAlw+vGvaB4XVGxkp3tozSLNtQZr0=";
  };

  vendorHash = "sha256-6bC9z0N5xCNXSMPioXA6XT17zE0XSdRBFyl38kbtb4o=";

  ldflags = [
    "-w"
    "-X=main.version=${version}"
  ];

  meta = {
    description = "Inventory CLI";
    homepage = "https://github.com/containdk/ic.git";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "ic";
  };
}
