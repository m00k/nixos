{ config, pkgs, pkgs-unstable, lib, myConfig, ... }:

let
  cfg = config.services.openclaw;
  downloadsPath = "/home/${myConfig.userName}/Downloads";
in
{
  options.services.openclaw = {
    enable = lib.mkEnableOption "OpenClaw AI Gateway";
  };

  config = lib.mkIf cfg.enable {
    users.users.openclaw = {
      isSystemUser = true;
      group = "openclaw";
      home = "/var/lib/openclaw";
      createHome = true;
    };
    users.groups.openclaw = { };

    environment.etc."openclaw/openclaw.json".text = builtins.toJSON {
      gateway = {
        bind = "loopback";
        port = 18789;
        mode = "local";
        auth = {
          mode = "token";
          token = "\${OPENCLAW_GATEWAY_TOKEN}";
        };
      };
      agents = {
        defaults = {
          model = "google/gemini-flash-lite-latest";
        };
      };
    };

    environment.etc."openclaw/openclaw-secrets".source = "/home/${myConfig.userName}/workspace/nixos/.secrets/openclaw-secrets";

    systemd.services.openclaw = {
      description = "OpenClaw AI Gateway";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        ExecStart = "${pkgs-unstable.openclaw}/bin/openclaw gateway";
        EnvironmentFile = "/etc/openclaw/openclaw-secrets";
        Environment = [
          "OPENCLAW_STATE_DIR=/var/lib/openclaw"
          "OPENCLAW_CONFIG_PATH=/etc/openclaw/openclaw.json"
        ];
        User = "openclaw";
        Group = "openclaw";
        ReadWritePaths = [ downloadsPath ];

        ProtectSystem = "full";
        ProtectHome = true;

        # Kernel & Privilege restrictions
        NoNewPrivileges = true;
        CapabilityBoundingSet = "";
        RestrictAddressFamilies = [ "AF_INET" "AF_INET6" "AF_UNIX" "AF_NETLINK" ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        # MemoryDenyWriteExecute = true; # incompatible with JIT (NodeJS, Java, Python, ...)
        LockPersonality = true;
        ProtectControlGroups = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        PrivateTmp = true;
        PrivateDevices = true;
      };
    };

  };
}
