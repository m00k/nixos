{ config, lib, pkgs, myConfig, ... }:

{
  imports = [
    ./jellyfin.nix
  ];

  # extend system/packages here
  environment.systemPackages = with pkgs; [
  ];

  # virtualisation
  virtualisation = {
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
