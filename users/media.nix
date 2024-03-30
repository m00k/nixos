{ config, lib, pkgs, myConfig, ... }:

with lib.hm.gvariant;
{
  imports = [
    ../home/home.nix
    ../home/browsers
    ../home/browsers/firefox.nix # TODO: mkOption
    ../home/editor.nix
    ../home/gnome.nix
    ../home/media.nix
    ../home/shell.nix
  ];

  # https://nixos.org/manual/nixos/stable/#sec-gnome-gsettings-overrides
  # https://nix-community.github.io/home-manager/options.xhtml#opt-dconf.settings
  # https://determinate.systems/posts/declarative-gnome-configuration-with-nixos
  # https://hoverbear.org/blog/declarative-gnome-configuration-in-nixos/
  #   run `dconf watch /` and set whatever option you're looking to declaratively persist, and observe the output
  dconf = {
    settings = {
      "org/gnome/settings-daemon/plugins/power" = {
        sleep-inactive-ac-type = lib.mkForce "nothing"; # TODO: mkOption
        power-button-action = lib.mkForce "interactive";
      };
    };
  };
}
