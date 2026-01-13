# Run pre-commit checks (with 'prek')
pre-commit files="":
    @prek run {{ files }}

# Run (Nix) pre-commit checks (with 'prek')
pre-commit-nix files="":
    @prek run -c ./.pre-commit-config-nix.yaml {{ files }}

# Show TODO and FIXME notes
todo:
    @rg --hidden --sort=path --glob="!.justfile" "TODO|FIXME"
