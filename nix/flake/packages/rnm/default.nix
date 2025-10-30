{
  srcPath ? ./.,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation {
  pname = "rnm";
  version = "0-unstable-2024-03-29";

  dontUnpack = true;

  installPhase = ''
    install -D -m755 "${srcPath}" "$out/bin/rnm"
  '';
}
