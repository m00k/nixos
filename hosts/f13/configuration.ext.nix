{ config, lib, pkgs, myConfig, ... }:

{
  # extend system/packages here
  environment.systemPackages = with pkgs; [
  ];

  # no password when sudoing
  security.sudo.wheelNeedsPassword = false;

  # virtualisation
  virtualisation = {
    virtualbox.host.enable = true;

    vmVariant = {
      # https://nixos.wiki/wiki/NixOS:nixos-rebuild_build-vm
      # following configuration is added only when building VM with build-vm
      virtualisation = {
        memorySize = 8 * 1024;
        cores = 4;
      };
    };
  };
}
