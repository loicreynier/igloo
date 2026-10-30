#!/usr/bin/env python3

"""Render script templates by resolving `$___INCLUDE"<target>"`

Usage: render.py <template>

Must be run from the directory containing this script.
The output is written to the upper directory, with the same file name.
Include paths are resolved relative to the including file's directory.
The shebang line and following blank line of included files are skipped.
"""

# TODO: pre-commit script

import re
import sys
from pathlib import Path

DIRECTIVE = re.compile(r'^\$___INCLUDE\s+"([^"]+)"\s*$')

if sys.stderr.isatty():
    USAGE = (
        "\033[1;32mUsage:\033[0m \033[1;36mrender.py\033[0;36m <template>\033[0m\n"
        + "\n".join(__doc__.strip().splitlines()[3:])
    )
else:
    USAGE = "\n".join(__doc__.strip().splitlines()[2:])


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
    if Path.cwd() != Path(__file__).resolve().parent:
        print_error(
            f"must be run from template directory: {Path(__file__).resolve().parent}"
        )

    if len(sys.argv) != 2:
        sys.exit(USAGE)

    template = Path(sys.argv[1])
    if not template.is_file():
        print_error(f"no such file: {template}")

    result = resolved_text(template.read_text(), template.parent)

    output = template.resolve().parent.parent / template.name
    output.write_text(result)


if __name__ == "__main__":
    main()
