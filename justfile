
list:
  @just --list --unsorted

check:
  nix flake check

enter:
  nixos-shell --flake .#default
