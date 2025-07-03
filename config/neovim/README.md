# Neovim configuration

> Welcome to the `rice_fields.lua`!

## About

Most of the classic Vim stuff is in `./lua/config` (see `./lua/config/options`, e.g.)
while (post-modern, jk) plugin configurations are in `./lua/plugins/lazy/<plugin-name>`.

## Keymaps logic

Keymaps are mainly inspired from [LazyVim's](https://www.lazyvim.org/keymaps).

| Base keymap | Logic                              |
| ----------- | ---------------------------------- |
| `<Leader>f` | "find" (mostly Telescope)          |
| `<Leader>s` | "search" (mostly Telescope)        |
| `<Leader>c` | "code" related (LSP & diagnostics) |
| `<Leader>g` | "git" related                      |
| `<Leader>t` | "terminal" related (`ToggleTerm`)  |
| `<Leader>u` | "UI" related and misc toggles      |
| `<Leader>x` | "eXtra" stuff (mostly Trouble)     |
| `<Leader>b` | "buffer" related                   |
| `<Leader>q` | "session" related                  |

## References

- [LazyVim](https://www.lazyvim.org)
- [AstroNvim](https://astronvim.com)
- [TJ's config](https://github.com/tjdevries/config.nvim)
- [Prime's config](https://github.com/ThePrimeagen/init.lua)
- [Dillon's config](https://github.com/dmmulroy/.dotfiles/tree/main/home/.config/nvim)
- [`lazy.nvim` on NixOS](https://nixalted.com/lazynvim-nixos.html)
