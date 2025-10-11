{ lib
, buildGoModule
, fetchFromGitHub
, pkg-config
, mpv
}:

buildGoModule rec {
  pname = "stmps";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "spezifisch";
    repo = "stmps";
    rev = "v${version}";
    hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  };

  vendorHash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    mpv
  ];

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "Subsonic Terminal Music Player S - A terminal client for *sonic music servers";
    homepage = "https://github.com/spezifisch/stmps";
    license = licenses.gpl3Only;
    maintainers = [ ];
    mainProgram = "stmps";
  };
}
