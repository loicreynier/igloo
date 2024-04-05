"""FZF history search inside IPython

Requires `fzf`, `bat`, and `pyfzf` Python package.
Sauce: https://stackoverflow.com/questions/48203949
"""

import IPython
from prompt_toolkit.enums import DEFAULT_BUFFER
from prompt_toolkit.keys import Keys
from prompt_toolkit.filters import HasFocus, HasSelection

try:
    from pyfzf import pyfzf
except ImportError:
    print("`pyfzf` package not installed. Please install to enable `fzf` Ctrl-R search")
    exit()

ipython = IPython.get_ipython()
fzf = pyfzf.FzfPrompt()


def _is_fzf_in_empty_line(buf) -> bool:
    text = buf.text
    cursor_position = buf.cursor_position
    text = text.split("\n")
    for line in text:
        if len(line) >= cursor_position:
            return not line
        else:
            cursor_position -= len(line) + 1


def _fzf_i_search(
    event,
    nevents=5000,
    bat_bin="bat",
    sed_bin="sed",
) -> None:
    history_set = set()
    history_strings = [i[2] for i in ipython.history_manager.get_tail(nevents)][::-1]

    # Replace newlines as `fzf` can only work on single lines
    history_strings = [
        s.replace("\n", " @@ ")
        for s in history_strings
        if not (s in history_set or history_set.add(s))
    ]

    print("", end="\r", flush=True)  # Refresh prompt
    try:
        text = fzf.prompt(
            history_strings,
            fzf_options="--no-sort --multi --border --height=80% --margin=1 --padding=1"
            " --preview 'echo {}"
            f' | {sed_bin} "s/ @@ /\\n/g"'
            f" | {bat_bin} --color=always --style=numbers -l py -'",
        )
        text = "\n\n".join(text)  # Concatenate multiple returns
        text = text.replace(" @@ ", "\n")  # Reverse newline replacement
    except Exception:  # TODO: finier exception handling
        return
    buf = event.current_buffer
    if not _is_fzf_in_empty_line(buf):
        buf.insert_line_below()
    buf.insert_text(text)


# Register the shortcut if IPython is using prompt_toolkit
if getattr(ipython, "pt_app", None):
    registry = ipython.pt_app.key_bindings
    registry.add_binding(
        Keys.ControlR,
        filter=(HasFocus(DEFAULT_BUFFER) & ~HasSelection()),
    )(_fzf_i_search)

del DEFAULT_BUFFER, Keys, HasFocus, HasSelection
del _fzf_i_search
