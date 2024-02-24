# IPython default profile configuration file

# `c` is not defined in that file, stop complaining ruff
# ruff: noqa: F821

c.TerminalPythonApp.display_banner = False
c.TerminalInteractiveShell.confirm_exit = False
c.InteractiveShellApp.extensions = [
    "autoreload",
]
c.InteractiveShellApp.exec_lines = [
    "%autoreload all",  # Reload all modules every time before executing
]
