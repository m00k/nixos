{ config, lib, pkgs, myConfig, ... }:

{
  imports = [
    ./jellyfin.nix
  ];

  # extend system/packages here
  environment.systemPackages = with pkgs; [
  ];

  # no password when sudoing
  security.sudo.wheelNeedsPassword = false;

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

  # remote desktop
  services.gnome.gnome-remote-desktop.enable = true;
  networking.firewall.allowedTCPPorts = [ 3389 ];

  # prevent sleep when not logged in
  # https://discourse.nixos.org/t/stop-pc-from-sleep/5757
  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;
}
