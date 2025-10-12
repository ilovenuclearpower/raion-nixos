{ lib
, buildGoModule
, fetchFromGitHub
, pkg-config
, mpv
, libGL
, xorg
, mesa
, libglvnd
}:

buildGoModule rec {
  pname = "stmps";
  version = "0.0.2";

  src = fetchFromGitHub {
    owner = "spezifisch";
    repo = "stmps";
    rev = "v${version}";
    hash = "sha256-KpyIxPyXghCJL+5awTJGvyXgzQ8dBgGZJu9Z+tXohw0=";
  };

  vendorHash = "sha256-53Oat/48PtOXtITxU5j1VmHy0vCB6UzyqjDzkfZFrYI=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    mpv
    libglvnd.dev
    xorg.libX11
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
