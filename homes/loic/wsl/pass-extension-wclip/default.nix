{
  stdenv,
  installShellFiles,
}:
stdenv.mkDerivation {
  pname = "pass-wclip";
  version = "unstable-2024-02-15";

  src = ./.;

  dontBuild = true;

  nativeBuildInputs = [
    installShellFiles
  ];

  installPhase = ''
    install -D "./wclip.bash" "$out/lib/password-store/extensions/wclip.bash"
  '';

  # FIXME: completion file seems not sourced
  postPatch = ''
    installShellCompletion --bash "./pass-wclip.bash"
  '';
}
