{ inputs, config, ... }:
{
  systems = [ "x86_64-linux" ];

  flake.nixosConfigurations.default = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";

    modules = [
      config.flake.nixosModules.zsh
      config.flake.nixosModules.mdt
    ];
  };
}
