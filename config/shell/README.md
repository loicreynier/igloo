# (global) Shell profile

> Standalone and portable shell `~/.profile` for system-aware configuration.

`~/.profile` sets up core environment variables
(paths, locales, editor, XDG directories, Nix/Home Manager)
and software defaults (config path, cache path, etc.).
Most software configuration variables belong here so they can be inherited by other programs.

The system is detected via `hostname` to set variables used by other programs such as:
- `$SYSTEM`
- `$SYSTEM_OPTIONS`
- `$SYSTEM_THEME`
- `$SYSTEM_CMD_PASTE`
- `$SYSTEM_CMD_COPY`

Different `$SYSTEM` values trigger corresponding shell configurations (paths, variables, modules).
Shell configurations are stored as `setup_shell_*` functions which can be invoked manually
if automatic system detection fails.
This structure ensure portability, modularity, and easy customization
across multiple machines and HPC systems.
