{ config, lib, pkgs, myConfig, ... }:

{
  # extend system/packages here
  environment.systemPackages = with pkgs; [
    micro
    google-chrome
    slack
    libreoffice
    azure-functions-core-tools
    nodejs_22
    wireguard-tools
    github-copilot-cli
  ];

  # no password when sudoing
  security.sudo.wheelNeedsPassword = false;

  # https://nixos.wiki/wiki/Fwupd
  # https://knowledgebase.frame.work/en_us/framework-laptop-bios-and-driver-releases-amd-ryzen-7040-series-r1rXGVL16
  services.fwupd.enable = true;

  # virtualisation
  virtualisation = {
    virtualbox.host.enable = true;

    vmVariant = {
      # https://nixos.wiki/wiki/NixOS:nixos-rebuild_build-vm
      # following configuration is added only when building VM with build-vm
      virtualisation = {
        memorySize = 8 * 1024;
        cores = 4;
      };
    };
  };

  # WireGuard
  # https://nixos.wiki/wiki/WireGuard
  # sudo systemctl list-units *wg0*
  # sudo wg
  # sudo wg showconf wg0
  # manually start/stop (up/down) using a config file:
  # sudo wg-quick up /etc/nixos/wg0.conf
networking.wg-quick.interfaces = {
  wg0 = {
    address = [ "10.111.108.13/32" ];
    privateKeyFile = "/home/${myConfig.userName}/workspace/nixos/.secrets/wg.privateKey.nix";
    mtu = 1420;
    dns = [ "1.1.1.1" ];
    
    peers = [
      {
        publicKey = "jXLA+/Cs+/p3henZM/HQjr4JQQtjepQe90ELppIJPmM=";
        presharedKeyFile = "/home/${myConfig.userName}/workspace/nixos/.secrets/wg.peers.presharedKey.nix";
        allowedIPs = [ "0.0.0.0/0" ];
        endpoint = builtins.readFile "/home/${myConfig.userName}/workspace/nixos/.secrets/wg.peers.endpoint.nix";
        persistentKeepalive = 21;
      }
    ];
  };
};
}
