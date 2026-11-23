# Tooling

## Mise and prek integration

The prek hooks are configured to use the `system` language and Mise-managed binaries.
Alternatively, they could be configured to use the `mise` language,
eliminating the need for a separate Mise configuration file.
However, because the repository already requires Mise to install tools unrelated to the hooks,
it is simpler to manage all tooling in one place.
