# TODO: add documentation

import atexit
import readline
import importlib
import os


def execfile(path: str) -> None:
    """Execute file from `path`."""
    exec(open(path, encoding="utf-8").read())


def _save_history(prev_history_len: int, file_: str) -> None:
    """Save console history in `file_`."""
    new_history_len = readline.get_current_history_length()
    readline.set_history_length(10000)
    readline.append_history_file(new_history_len - prev_history_len, file_)


_history_file = os.environ.get("XDG_STATE_HOME", "@state@") + "/python_history"

try:
    readline.read_history_file(_history_file)
    _history_len = readline.get_current_history_length()
except FileNotFoundError:
    open(_history_file, "wb").close()
    _history_len = 0

_module = ""
_alias = ""
for _module in os.environ.get("PYTHONMODULES", "").split(":"):
    if _module != "":
        _alias = _module.split("=")[1] if "=" in _module else _module
        locals()[_alias] = importlib.import_module(_module.split("=")[0])

del _module, _alias

atexit.register(_save_history, _history_len, _history_file)
