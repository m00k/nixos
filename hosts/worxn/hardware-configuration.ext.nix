{ config, lib, pkgs, myConfig, ... }:

{
  boot.supportedFilesystems = [ "ntfs" ];

  # works around wifi issue:
  # 'Authentication Required. System policy prevents modification of network settings for all users'
  systemd.services.NetworkManager-wait-online.enable = false;
}
