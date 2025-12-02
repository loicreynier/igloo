{
  lib,
  srcPath ? ./.,
  stdenvNoCC,
  makeWrapper,
  imagemagick,
  ffmpeg,
  poppler-utils,
}:
stdenvNoCC.mkDerivation {
  pname = "x2y";
  version = "0-unstable-2024-04-29";

  dontUnpack = true;

  nativeBuildInputs = [
    makeWrapper
  ];

  installPhase = ''
    install -D -m755 "${srcPath}" "$out/bin/x2y"
  '';

  postFixup = ''
    wrapProgram "$out/bin/x2y" --prefix PATH : "${
      lib.makeBinPath [
        imagemagick
        ffmpeg
        poppler-utils
      ]
    }"
  '';
}
