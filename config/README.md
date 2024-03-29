# Raw configuration files

Sometimes configurations files do not benefit from being generated by Nix/Home Manager
and can be simply imported.
When working on complex configurations it's also easier to get the full IDE experience
rather than working in Nix multiline strings.

These configurations files do not contain Nix expressions and can be imported in non-Nix systems.

- [`bash/functions`](./bash/functions):
  Bash functions (with associated keybinding) imported in `~/.bashrc`
- [`bat`](./bat):
  default `bat` CLI arguments (different files for different themes/styles)
- [`direnv`](./direnv):
  `direnv` configuration with cache in `~/.cache/direnv/layouts` and daemonization
- [`editorconfig`](./editorconfig):
  EditorConfig with rules for all files I work with outside of repos.
- [`ipython`](./ipython): IPython shell configuration with autoreload
- [`python`](./python): Python shell configuration
  with history in `$XDG_STATE_HOME/python_history`
  and auto-import modules from `$PYTHONMODULES`
- [`readline`](./readline): GNU Readline configuration (for Bash) with some completion tweaks
- [`ripgrep`](./ripgrep): default `rg` CLI arguments
- [`starship`](./starship): mostly Starship default config, just a little more verbose