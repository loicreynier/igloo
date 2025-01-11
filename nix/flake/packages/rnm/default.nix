{
  lib,
  srcPath ? ./.,
  stdenvNoCC,
  makeWrapper,
  imagemagick,
  ffmpeg,
  poppler_utils,
}:
stdenvNoCC.mkDerivation {
  pname = "rnm";
  version = "0-unstable-2024-03-29";

  dontUnpack = true;

  nativeBuildInputs = [
    makeWrapper
  ];

  installPhase = ''
    install -D -m755 "${srcPath}" "$out/bin/rnm"
  '';

  postFixup = ''
    wrapProgram "$out/bin/rnm" --prefix PATH : "${
      lib.makeBinPath [
        imagemagick
        ffmpeg
        poppler_utils
      ]
    }"
  '';
}
