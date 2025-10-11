{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

stdenv.mkDerivation rec {
  pname = "codecrafters";
  version = "40"; # v40 is the current version

  src = fetchurl {
    url = "https://github.com/codecrafters-io/cli/releases/download/v${version}/v${version}_linux_${
      if stdenv.hostPlatform.isAarch64 then "arm64" else "amd64"
    }.tar.gz";
    sha256 = lib.fakeSha256; # Nix will tell you the real hash on first build
  };

  nativeBuildInputs = lib.optional stdenv.isLinux autoPatchelfHook;

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall
    
    mkdir -p $out/bin
    install -m755 codecrafters $out/bin/codecrafters
    
    runHook postInstall
  '';

  meta = with lib; {
    description = "CodeCrafters CLI tool";
    homepage = "https://codecrafters.io";
    license = licenses.unfree; # Check actual license
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = [ ];
  };
}
