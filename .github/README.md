<!-- markdownlint-disable -->
<!-- editorconfig-checker-disable -->

<h1 align="center">:snowflake:</h1>

<p align="center">
    <a href="https://nixos.wiki/wiki/NixOS"
        ><img
            src="https://img.shields.io/badge/NixOS-23.11-5277c3?logo=nixos&logoColor=white"
            alt="NixOS"
    /></a>
    <a href="https://github.com/NixOS/nixpkgs"
        ><img
            src="https://img.shields.io/badge/nixpkgs-unstable-5277c3?logo=nixos&logoColor=white"
            alt="nixpkgs"
    /></a>
    <a href="https://nixos.wiki/wiki/Home_Manager"
        ><img
            src="https://img.shields.io/badge/Home%20Manager-23.11-5277c3?logo=nixos&logoColor=white"
            alt="Home Manager"
    /></a>
</p>

<!-- editorconfig-checker-enable -->

## About

Home baked configurations for all my systems and user environments.
Using [Nix], [flakes], [flake parts] and [Home Manager].

[Nix]: https://nixos.org
[flakes]: https://nixos.wiki/wiki/Flakes
[flake parts]: https://github.com/hercules-ci/flake-parts
[Home Manager]: https://github.com/nix-community/home-manager

## Layout

- [`flake.nix`](./flake.nix): Entry point of the Igloo
- [`flake`](./flake): Individual parts of the flake, powered by flake parts
- [`homes`](./homes): Home Manager/user environment configuration
- [`hosts`](./hosts): NixOS/system configurations
- [`modules`](./modules): Configuration resources
  - [`igloo`](./modules/igloo): Home & system modularized configurations
  - [`home-manager`](./modules/home-manager): Home Manager custom modules
  - [`nixos`](./modules/nixos): Nix OS custom modules

## Credits & References

### System Configurations

> Igloo contains code ~~stolen~~ inspired from these configurations

<!-- LTeX: enabled=false -->

[@NotAShelf](https://github.com/NotAShelf/nyx) -
[@ViperML](https://github.com/viperML/dotfiles) -
[@fufexan](https://github.com/fufexan/dotfiles) -
[@sioodmy](https://github.com/sioodmy/dotfiles) -
[@zimbatm](https://github.com/zimbatm/home) -
[@nmasur](https://github.com/nmasur/dotfiles)

<!-- LTeX: enabled=true -->

### Software employed

> Software used to build Igloo and used within my systems

<!-- markdownlint-disable MD033 -->

<details><summary>Nix stuff</summary>

- [Nix Flakes](https://nixos.wiki/wiki/Flakes)
  to structure the configurations
- [Flake Parts](https://github.com/hercules-ci/flake-parts)
  to modularize even more the flake structure
- [Home Manager](https://github.com/nix-community/home-manager)
  to manage the user environment
- [`pre-commit-hooks.nix`](https://github.com/cachix/pre-commit-hooks.nix)
  to integrate [pre-commit](https://pre-commit.com) hooks in the Nix flake
- [NixOS on WSL](https://github.com/nix-community/NixOS-WSL)
  for running NixOS on WSL
- [comma](https://github.com/nix-community/comma)
  to run software without installing it
- [NixVim](https://github.com/nix-community/nixvim)
  to configure Neovim using Nix
- [NixNeovimPlugins](https://github.com/nixneovim/nixneovimplugins)
  to use Neovim plugins not available yet in `nixpkgs`

</details>

<details><summary>Shell environment</summary>

- [direnv](https://direnv.net)
  for loading/deloading development environments depending on the current directory
- [Starship](https://starship.rs)
  because having a beautiful prompt is vital

</details>

<!-- markdownlint-enable MD033 -->
<!-- markdownlint-disable -->
<!-- editorconfig-checker-disable -->

---

<div align="right">
    <a href="#readme">Back to the Top</a>
</div>
