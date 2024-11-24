{ config, lib, pkgs, myConfig, ... }:

{
  boot.supportedFilesystems = [ "ntfs" ];

  # works around wifi issue:
  # 'Authentication Required. System policy prevents modification of network settings for all users'
  # https://discourse.nixos.org/t/rebuild-error-failed-to-start-network-manager-wait-online/41977
  # systemd.services.NetworkManager-wait-online.enable = false;
}
