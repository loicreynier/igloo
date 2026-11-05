#!/usr/bin/env python3

"""Render script templates by resolving `$___INCLUDE"<target>"`

Usage: render.py <script-template>

The output is written to the upper directory, with the same file name.
Include paths are resolved relative to the including file's directory.
The shebang line and following blank line of included files are skipped.
"""

# TODO: add an option to update the script when the libraries are updated (pre-commit)
# TODO: integrate with main Igloo script

import os
import re
import sys
from pathlib import Path
from typing import TextIO

DIRECTIVE = re.compile(r'^\$___INCLUDE\s+"([^"]+)"\s*$')


def print_usage(stream: TextIO) -> None:
    if stream.isatty():
        stream.write(
            "\033[1;32mUsage:\033[0m \033[1;36mrender.py\033[0;36m <template>\033[0m\n"
        )
    else:
        stream.write(__doc__.strip().splitlines()[2])


def print_help(stream: TextIO) -> None:
    if stream.isatty():
        stream.write(
            "\033[1;32mUsage:\033[0m \033[1;36mrender.py\033[0;36m <template>\033[0m\n"
            + "\n".join(__doc__.strip().splitlines()[3:])
        )
    else:
        stream.write("\n".join(__doc__.strip().splitlines()[2:]))


def print_error(text: str) -> None:
    if sys.stderr.isatty():
        print(f"\033[1;31mError:\033[0m {text}", file=sys.stderr)
    else:
        print(f"Error: {text}", file=sys.stderr)
    sys.exit(1)


def resolved_text(text: str, basepath: Path) -> str:
    out = []
    for line in text.splitlines(keepends=True):
        match = DIRECTIVE.match(line.rstrip("\n"))
        if match is None:
            out.append(line)
            continue
        path = (basepath / match.group(1)).resolve()
        if not path.is_file():
            print_error(f"no such include: {path}")
        # Skip the shebang line and the blank line after it.
        included = resolved_text(path.read_text(), path.parent)
        out.append("".join(included.splitlines(keepends=True)[2:]))
    return "".join(out)


def main() -> None:
    if len(sys.argv) != 2:
        print_usage(sys.stderr)
        sys.exit(1)
    if sys.argv[1] in ("--help", "-h", "-?"):
        print_help(sys.stdout)
        sys.exit(0)

    template_path = Path(sys.argv[1]).resolve()
    if not template_path.is_file():
        print_error(f"no such file: {template_path}")

    script_dir = Path(__file__).resolve().parent
    if Path.cwd() != script_dir:
        os.chdir(script_dir)

    result = resolved_text(template_path.read_text(), template_path.parent)

    output = template_path.parent.parent / template_path.name
    output.write_text(result)

    if sys.stdout.isatty():
        sys.stdout.write(f"{template_path} -> {output}")


if __name__ == "__main__":
    main()
