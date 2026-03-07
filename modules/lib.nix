{ ... }:
{
  flake.lib.mapAttr = f: list: builtins.listToAttrs (map f list);
}
