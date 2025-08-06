{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "ic";
  version = "0.10.5";

  src = fetchFromGitHub {
    owner = "containdk";
    repo = "ic";
    rev = "v${version}";
    hash = "sha256-n/qUeJcKKQhBWOj5K2B7BX8WYYLNh0kdBcQ6eFKF+mI=";
  };

  vendorHash = "sha256-SVrWlbVspACaMW1jT8MPL/t3pcE60T/6a9sEY9NSS3w=";

  ldflags = [
    "-s"
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
