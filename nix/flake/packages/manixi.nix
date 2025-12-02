{
  lib,
  srcPath ? ./.,
  stdenvNoCC,
  makeWrapper,
  manix,
  fzf,
  bat,
}:
stdenvNoCC.mkDerivation {
  pname = "manixi";
  version = "0-unstable-2025-12-02";

  dontUnpack = true;

  nativeBuildInputs = [
    makeWrapper
  ];

  installPhase = ''
    install -D -m755 "${srcPath}" "$out/bin/manixi"
  '';

  postFixup = ''
    wrapProgram "$out/bin/manixi" --prefix PATH : "${
      lib.makeBinPath [
        fzf
        bat
        manix
      ]
    }"
  '';
}
