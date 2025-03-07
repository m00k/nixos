{ config, lib, pkgs, myConfig, ... }:

{
  # extend system/packages here
  environment.systemPackages = with pkgs; [
    micro
    google-chrome
    slack
    libreoffice
    azure-functions-core-tools
    nodejs_22
  ];

  # no password when sudoing
  security.sudo.wheelNeedsPassword = false;

  # https://nixos.wiki/wiki/Fwupd
  # https://knowledgebase.frame.work/en_us/framework-laptop-bios-and-driver-releases-amd-ryzen-7040-series-r1rXGVL16
  services.fwupd.enable = true;

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
