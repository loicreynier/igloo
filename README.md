# Igloo

## About

Home baked configurations for all my systems and user environments.
Using [Nix], [flakes], [flake parts] and [Home Manager].

[Nix]: https://nixos.org
[flakes]: https://nixos.wiki/wiki/Flakes
[flake parts]: https://github.com/hercules-ci/flake-parts
[Home Manager]: https://github.com/nix-community/home-manager

## Layout

- [`bin`](./bin): raw executable/script files (not generated using Nix)
- [`config`](./config): raw configuration files (not generated using Nix)
- [`flake.nix`](./flake.nix): Entry point of the Igloo
- [`flake`](./flake): Individual parts of the flake, powered by flake parts
- [`homes`](./homes): Home Manager/user environment configuration
- [`hosts`](./hosts): NixOS/system configurations
- [`modules`](./modules): Configuration resources
  - [`igloo`](./modules/igloo): Home & system modularized configurations
  - [`home-manager`](./modules/home-manager): Home Manager custom modules
  - [`nixos`](./modules/nixos): Nix OS custom modules
- [`secrets`](./secrets):
  `age`-encrypted secrets
  such as passwords and private keys

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
  and [`nix-index` database](https://github.com/nix-community/nix-index-database)
  to run software without installing it
- [NixVim](https://github.com/nix-community/nixvim)
  to configure Neovim using Nix
- [NixNeovimPlugins](https://github.com/nixneovim/nixneovimplugins)
  to use Neovim plugins not available yet in `nixpkgs`
- [NixOS Visual Studio Code `server-env-setup`](https://github.com/sonowz/vscode-remote-wsl-nixos)
  to connect to VS Code server running inside NixOS-WSL
- [`agenix`](https://github.com/ryantm/agenix)
  from managing `age`-encrypted secrets from NixOS and Home Manager

</details>

<details><summary>Shell environment</summary>

- [direnv](https://direnv.net)
  for loading/deloading development environments depending on the current directory
- [Starship](https://starship.rs)
  because having a beautiful prompt is vital
- [zoxide](https://github.com/ajeetdsouza/zoxide)
  because `cd`-ing is boring and `z` is a fast boy
- [pet](https://github.com/knqyf263/pet)
  to remember the juiciest commands

</details>

<details><summary>Misc</summary>

- [Sourcegraph](https://sourcegraph.com)
  to scavenge the entire web for Nix snippets using `file:\.nix <query>`

</details>
