import importlib
import os
import sys


# -- Utility functions
def execfile(path):
    """Execute file from `path`."""
    exec(open(path, encoding="utf-8").read())


# -- Save history to `$XDG_STATE_HOME/python_history` for Python < 3.13
# Python 3.13 has this functionnaliy built in with `$PYTHON_HISTORY`.
def _save_history(prev_history_len, file_):
    """Save console history in `file_`."""
    new_history_len = readline.get_current_history_length()
    readline.set_history_length(10000)
    readline.append_history_file(new_history_len - prev_history_len, file_)


try:
    get_ipython()
    _ipython_shell = True
except NameError:
    _ipython_shell = False
    pass

_version = sys.version_info
if _version < (3, 13) and not _ipython_shell:
    try:
        import atexit
        import readline

        # -- Python 2
        if _version < (3,):
            _history_file = (
                os.environ.get("XDG_STATE_HOME", "@state@")
                + "/python2_history"
            )
            try:
                readline.read_history_file(_history_file)
            except IOError:
                pass
            atexit.register(readline.write_history_file, _history_file)

        # -- Python 3 < 3.13
        else:
            _history_file = (
                os.environ.get("XDG_STATE_HOME", "@state@")
                + "/python_history"
            )
            try:
                readline.read_history_file(_history_file)
                _history_len = readline.get_current_history_length()
            except FileNotFoundError:
                open(_history_file, "wb").close()
                _history_len = 0
            atexit.register(_save_history, _history_len, _history_file)

    except ImportError:
        pass

# -- Auto import modules set in `$PYTHONMODULES`
_module = ""
_alias = ""
for _module in os.environ.get("PYTHONMODULES", "").split(":"):
    if _module != "":
        _alias = _module.split("=")[1] if "=" in _module else _module
        locals()[_alias] = importlib.import_module(_module.split("=")[0])

del _module, _alias, _version, _ipython_shell
