{ config, pkgs, myConfig, ... }:

{
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    brave
    git
    gnupg1orig
    lf
    micro
    neofetch
    nixpkgs-fmt
    ripgrep # rg
    vlc
    xclip # wl-clipboard-x11
  ];

  services.plex = {
    enable = true;
    openFirewall = true;
    user = myConfig.userName; # https://nixos.wiki/wiki/Plex
  };
}
