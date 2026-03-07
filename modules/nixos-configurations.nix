{ inputs, config, ... }:
let
  inherit (config.flake.lib) mapAttr;
  keyFiles = [ ../keys/id_ed25519_t14.pub ];
  superUsers = [ "sshine" ];
  mkSuperUser = name: {
    inherit name;
    value = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      openssh.authorizedKeys.keyFiles = keyFiles;
    };
  };
in
{
  systems = [ "x86_64-linux" ];

  flake.nixosConfigurations.default = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      config.flake.nixosModules.zsh
      (
        { ... }:
        {
          system.stateVersion = "25.05";
          networking.hostName = "nixos";
          services.openssh = {
            enable = true;
            settings.PasswordAuthentication = false;
          };
          users.users = mapAttr mkSuperUser superUsers;
        }
      )
    ];
  };
}
