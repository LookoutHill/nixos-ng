{ inputs, ... }:
{
  systems = [ "x86_64-linux" ];

  flake.nixosConfigurations.default = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      {
        system.stateVersion = "25.05";
        networking.hostName = "nixos";
        services.openssh = {
          enable = true;
          settings.PasswordAuthentication = false;
        };
        users.users.root.openssh.authorizedKeys.keyFiles = [
          ../keys/id_ed25519_t14.pub
        ];
      }
    ];
  };
}
