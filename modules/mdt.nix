{ inputs, config, ... }:
let
  superUsers = [ "matt" ];
  keyFiles = [ ../keys/matt.pub ];
  mkSuperUser =
    name:
    {
      inherit name;
      value = {
        isNormalUser = true;
        extraGroups = [ "wheel" ];
        openssh.authorizedKeys.keyFiles = keyFiles;
      };
    };
  inherit (config.flake.lib) mapAttr;
in {
  flake.nixosModules.mdt =
    { ... }:
    {
      system.stateVersion = "25.05";

      networking.hostName = "mdt";

      services.openssh = {
        enable = true;

        settings = {
          PasswordAuthentication       = false;
          KbdInteractiveAuthentication = false;
          PermitRootLogin              = "no";
        };

        hostKeys = [
          { type = "ed25519"; bits = 256; path = "/etc/ssh/ssh_host_ed25519_key"; }
        ];
      };

      users.users = mapAttr mkSuperUser superUsers;
    };
}
