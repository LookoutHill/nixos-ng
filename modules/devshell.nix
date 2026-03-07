{ self, inputs, ... }:
{
  perSystem =
    {
      config,
      system,
      pkgs,
      lib,
      ...
    }:
    let
      lefthook-check = inputs.lefthook-nix.lib.${system}.run {
        src = self;
        config = {
          pre-commit.commands.treefmt = {
            run = "${lib.getExe config.treefmt.build.wrapper} {staged_files}";
          };
        };
      };
    in
    {
      checks.lefthook-check = lefthook-check;
      devShells.default = pkgs.mkShell {
        inherit (lefthook-check) shellHook;
      };
    };
}
