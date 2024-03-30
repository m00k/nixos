{ config, lib, pkgs, myConfig, ... }:

with lib.hm.gvariant;
{
  # https://nixos.org/manual/nixos/stable/#sec-gnome-gsettings-overrides
  # https://nix-community.github.io/home-manager/options.xhtml#opt-dconf.settings
  # https://determinate.systems/posts/declarative-gnome-configuration-with-nixos
  # https://hoverbear.org/blog/declarative-gnome-configuration-in-nixos/
  #   run `dconf watch /` and set whatever option you're looking to declaratively persist, and observe the output
  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        enable-hot-corners = false;
        show-battery-percentage = true;
      };
      "org/gnome/desktop/session" = {
        idle-delay = mkUint32 900;
      };
      "org/gnome/settings-daemon/plugins/power" = {
        sleep-inactive-battery-timeout = mkUint32 900;
        sleep-inactive-ac-type = "suspend";
        sleep-inactive-ac-timeout = mkUint32 1200;
        power-button-action = "hibernate";
        power-saver-profile-on-low-battery = false;
      };
      "org/gnome/desktop/peripherals/keyboard" = {
        delay = mkUint32 175;
        repeat-interval = mkUint32 18;
        repeat = true;
      };
      "org/gnome/desktop/sound" = {
        event-sounds = false;
      };
      # TODO: doesn't seem to work
      "org/gnome/settings-daemon/plugins/media-keys" = {
        screensaver = "['<Super>q']";
      };
    };
  };
}
