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

  ### Remote Desktop ###
  # 1. Enable GNOME and the Remote Desktop service
  # base configuration.nix: services.desktopManager.gnome.enable = true; 
  services.gnome.gnome-remote-desktop.enable = true;

  # 2. Ensure the service starts at boot (not just when logged in)
  systemd.services.gnome-remote-desktop.wantedBy = [ "graphical.target" ];

  # 3. Open the RDP port in the firewall
  networking.firewall.allowedTCPPorts = [ 3389 ];
  networking.firewall.allowedUDPPorts = [ 3389 ];

  # 4. Disable auto-login to prevent session conflicts
  services.displayManager.autoLogin.enable = false;

  # Note: After applying this, you must log in locally once to Settings > Sharing > Remote Desktop to set your username and password for the RDP connection.
  ### Remote Desktop End ###

  # prevent sleep when not logged in
  # https://discourse.nixos.org/t/stop-pc-from-sleep/5757
  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;
}
