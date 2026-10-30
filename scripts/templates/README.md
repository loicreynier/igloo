# Shell scripts templates

Small template system for keeping shared shell script code
-- most notably the `usage` "library" -- in one place, and generate standalone script from it.

## Layout

    scripts/
    ├── templates/
    │   ├── render.py    # Template renderer
    │   └── hello.bash   # Script
    ├── lib/             # Shared, includable snippets
    │   └── usage.bash
    └─ hello.bash        # Rendered script

## Usage

```bash
./render.py hello.bash
```

The renderer replace the directive `$___INCLUDE "lib/usage.bash"` by the content of `lib/usage.bash`.

> [!WARNING]
> The first two lines of the included file are skipped (shebang + blank line)

