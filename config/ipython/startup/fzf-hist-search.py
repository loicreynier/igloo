"""`fzf`-powered history search inside IPython

- Ctrl-R opens `fzf` over command history
- Multi-select inserts commands separated by blank lines
- ESC / Ctrl-C cancels without modifying the buffer

Requires `fzf`, `bat` binaries installed, and `pyfzf` Python package.
"""

import IPython
import sys
from prompt_toolkit.enums import DEFAULT_BUFFER
from prompt_toolkit.keys import Keys
from prompt_toolkit.filters import HasFocus, HasSelection


def _fzf_i_search(
    event,
    nevents=5000,
    bat_cmd="bat",
    sed_cmd="sed",
    sentinel="\x1f ↳ \x1f",
) -> None:
    """Perform interactive history search using `fzf`.

    Intended to be bound to a key (typically Ctrl-R) in `prompt_toolkit`-enabled
    IPython shells. It allows browsing and selecting recent command history,
    including multi-line commands.

    Multi-line commands are temporarily replaced with a sentinel string
    because `fzf` operates on single lines. After selection, the sentinel string
    is replaced back with actual newlines.

    Behavior:
        - Refreshes the prompt before launching `fzf`
        - Allows multi-selection; selected commands are concatenated with
          two newlines between them.
        - Inserts the selected text below the current line if the cursor
          is not on an empty line.
        - ESC or Ctrl-C cancels without modifying the buffer.

    References:
        - https://stackoverflow.com/a/76867391 for initial implementation
    """

    def _is_fzf_in_empty_line(buf) -> bool:
        """Whether the cursor is currently on an empty line."""
        text = buf.text
        cursor = buf.cursor_position
        line_start = text.rfind("\n", 0, cursor) + 1
        line_end = text.find("\n", cursor)
        if line_end == -1:
            line_end = len(text)
        return text[line_start:line_end] == ""

    # Collect history, remove dups and replace newlines by sentinel string
    seen = set()
    history_strings = [
        cmd.replace("\n", sentinel)
        for _, _, cmd in reversed(ipython.history_manager.get_tail(nevents))
        if cmd not in seen and not seen.add(cmd)
    ]

    if not history_strings:
        return

    # Refresh prompt before launching `fzf`
    print("", end="\r", flush=True)

    fzf_options = (
        "--no-sort --multi --border --height=40% "
        "--margin=1 --padding=1 --reverse "
        "--preview 'echo {}"
        f' | {sed_cmd} "s/{sentinel}/\\n/g"'
        f" | {bat_cmd} --color=always --style=numbers -l py -'"
    )

    try:
        text = fzf.prompt(history_strings, fzf_options=fzf_options)

    except (KeyboardInterrupt, EOFError):
        return

    except FileNotFoundError as e:
        sys.stderr.write(f"'fzf' history search failed (missing binary): {e}\n")
        return

    except RuntimeError as e:
        sys.stderr.write(f"'fzf' history search failed: {e}\n")
        return

    except Exception:
        raise

    if not text:
        return

    # Concatenate multi-select results and restore newlines
    text = "\n\n".join(text).replace(sentinel, "\n")

    buf = event.current_buffer
    if not _is_fzf_in_empty_line(buf):
        buf.insert_line_below()
    buf.insert_text(text)


try:
    from pyfzf import pyfzf
except ImportError:
    print("'pyfzf' not installed: Ctrl-R 'fzf' history search disabled")
    pyfzf = None

ipython = IPython.get_ipython()

if pyfzf is not None:
    fzf = pyfzf.FzfPrompt()


# Register the shortcut if IPython is using prompt_toolkit
if pyfzf is not None and getattr(ipython, "pt_app", None):
    registry = ipython.pt_app.key_bindings
    registry.add_binding(
        Keys.ControlR,
        filter=(HasFocus(DEFAULT_BUFFER) & ~HasSelection()),
    )(_fzf_i_search)

del DEFAULT_BUFFER, Keys, HasFocus, HasSelection
del _fzf_i_search
