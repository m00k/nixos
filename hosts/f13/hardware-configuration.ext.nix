{ config, lib, pkgs, myConfig, ... }:

{
  boot.supportedFilesystems = [ "ntfs" ];

  ### WiFi issue ###
  # 'Authentication Required: Password or encryption keys are required to access the wireless network ...'
  #
  # 1. Force driver flags via kernelParams (most reliable way)
  boot.kernelParams = [
    "mt7921e.disable_aspm=1"
    "mt76_connac_lib.vht_features=0"
    "mt76_connac_lib.he_features=0"
  ];
  # 2. NetworkManager Settings
  networking.networkmanager = {
    # enable = true;
    wifi.backend = "wpa_supplicant"; # Reverting for wider compatibility
    settings = {
      device = {
        "wifi.scan-rand-mac-address" = "no";
      };
      connection = {
        "wifi.powersave" = 3; # 3 = Disable
      };
    };
  };
  # 3. Ensure we aren't using randomized MACs which break handshakes
  # (This replaces the old extraConfig block)
  #
  # Keep the WPA2/PMF override file we created earlier
  environment.etc."NetworkManager/conf.d/wifi-stability.conf".text = ''
    [connection]
    wifi.key-mgmt=wpa-psk
    wifi.pmf=1 
  '';
  #
  ### WiFi issue END ###

}
