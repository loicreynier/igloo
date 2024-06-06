# Nix modules

Nix modules used to modularize the system and user environment configurations.

`home-manager` and `nixos` modules could be used on other Nix configurations as flake inputs
while `igloo` modules are not designed to be imported outside the igloo.

## Home Manager modules

- [`programs.python`](./home-manager/programs/python.nix):
  module to install and configure (shell startup, history location)
  a specific version of Python with packages.
- [`program.bat.installExtraSyntaxes`](./home-manager/programs/bat-extra-syntaxes.nix):
  option to install highlight extra (Sublime) syntaxes for
  BBCode, Justfiles, Gleam, Odin, Numbat, Typst.

## NixOS modules

- [`programs.comma`](./nixos/programs/comma.nix):
  module to install `comma` wrapped with `nix-index`.
