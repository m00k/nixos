{ config, lib, pkgs, myConfig, ... }:

{
  environment.systemPackages = with pkgs; [
    jellyfin
    jellyfin-web
    jellyfin-ffmpeg
  ];

  # https://nixos.wiki/wiki/Jellyfin
  services.jellyfin = {
    enable = true;
    openFirewall = true;
    user = myConfig.userName;
  };
}
