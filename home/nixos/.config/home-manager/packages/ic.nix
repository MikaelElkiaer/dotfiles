{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "ic";
  version = "0.11.2";

  src = fetchFromGitHub {
    owner = "containdk";
    repo = "ic";
    tag = "v${version}";
    hash = "sha256-rYzypU6VtGJTBrfAlw+vGvaB4XVGxkp3tozSLNtQZr0=";
  };

  vendorHash = "sha256-SVrWlbVspACaMW1jT8MPL/t3pcE60T/6a9sEY9NSS3w=";

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
