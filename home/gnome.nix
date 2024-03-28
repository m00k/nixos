{ config, lib, pkgs, myConfig, ... }:

{
  # https://nixos.org/manual/nixos/stable/#sec-gnome-gsettings-overrides
  # https://nix-community.github.io/home-manager/options.xhtml#opt-dconf.settings
  # https://determinate.systems/posts/declarative-gnome-configuration-with-nixos
  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
      "org/gnome/desktop/session" = {
        idle-delay = lib.hm.gvariant.mkUint32 1800;
      };
      "org/gnome/settings/daemon/plugins/power" = {
        sleep-inactive-ac-timeout = lib.hm.gvariant.mkUint32 1800;
      };
    };
  };
}
