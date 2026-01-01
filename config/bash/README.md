# Bash configuration

> Highly customized Bash configuration designed for standalone and portable use on multiple systems:
> - [`.bashrc`](./.bashrc): standalone Bash configuration file
> - [`functions`](./functions): utility functions (with associated keybindings),
>   should be installed in `$XDG_CONFIG_HOME/bash/functions` and imported by `.bashrc`.

`.bashrc` handles core configuration, such as
Bash options, aliases functions, and shell plugin installation (`eval "$(<software> init bash)"`),
while larger optional and larger functions are defined in `functions`.

Following the global shell [profile] logic,
plugin setup is deferred to functions that run only if the command exists.
For example, `_setup_bash_fzf` installs and configure `fzf` Bash integration
and is only when the `fzf` is available.
This allows running the setup functions manually is the Bash session.

System-specific settings use `$SYSTEM_...` variables from the global shell [profile].

[profile]: ../shell
