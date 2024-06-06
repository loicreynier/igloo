/*
Implement Flake Schemas

References:
- https://determinate.systems/posts/flake-schemas/
- https://gvolpe.com/blog/flake-schemas/
- https://github.com/gvolpe/nix-config/pull/254/files
*/
{inputs, ...}: {
  flake.schemas = inputs.flake-schemas.schemas;
}
