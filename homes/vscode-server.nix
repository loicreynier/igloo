/*
Try to make VS Code server work on NixOS (especially NixOS-WSL)

Uses the `server-env-setup` script by @sonowz to patch VS Code.
Source: https://github.com/sonowz/vscode-remote-wsl-nixos
Requires a NixOS system with `programs.nix-ld.enable = true`.

Not tested for SSH connection.
Might break on VS Code updates.

Working with:
- WSL 2.0.14.0
- VS Code 1.86.0
- nixpkgs 23.11

Alternatives:
- https://github.com/sonowz/vscode-remote-wsl-nixos
- https://discourse.nixos.org/t/14615

FIXME: this module is only needed if the system is running NixOS.
It therefore should be moved to `hosts` instead of `homes.
*/
{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
# let
#   nixosVSCodeServer = fetchTarball {
#     url = "https://github.com/nix-community/nixos-vscode-server/tarball/master";
#     sha256 = "sha256:0sz8njfxn5bw89n6xhlzsbxkafb6qmnszj4qxy2w0hw2mgmjp829";
#   };
#
#   # vscodeServer1_82Patch = pkgs.fetchpatch {
#     url = "https://github.com/nix-community/nixos-vscode-server/pull/68.patch";
#     hash = "sha256-kZWOcw3QKZK598nWj9UuMCJlQxQ/qzBKqACkQO8+jvI=";
#   };
#   vscodeServerSetup = fetchTarball {
#     url = "https://github.com/sonowz/vscode-remote-wsl-nixos/tarball/master";
#     sha256 = "sha256:0cf5l5gzwaqn1d0w3c6rcg0irxahzhwsnby5zdlifvgcgw74rxa6";
#   };
# in {
{
  home.packages = with pkgs; [
    wget
    curl
    coreutils
  ];

  home.file.".vscode-server/server-env-setup".text =
    builtins.replaceStrings
    [''$(nixos-version | cut -d "." -f1,2)'']
    ["${config.home.stateVersion}"]
    (lib.fileContents "${inputs.nixos-vscode-remote-wsl}/server-env-setup");

  # imports = [
  #   "${nixosVSCodeServer}/modules/vscode-server/home.nix"
  # ];
  #
  # services.vscode-server = {
  #   enable = true;
  #   # Patching requires `nix-community/nixos-vscode-server#74` to be merged.
  #   # postPatch = ''
  #   #   patch -p1 < ${vscodeServer1_82Patch}
  #   # '';
  #   enableFHS = lib.mkDefault true;
  #   nodejsPackage = pkgs.nodejs_21;
  #   extraRuntimeDependencies = lib.mkDefault [
  #     pkgs.curl
  #   ];
  # };
}
