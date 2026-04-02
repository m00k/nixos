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

    # Copy the secrets file into /etc/openclaw/openclaw-secrets
    # NOTE: This makes the file world-readable in /nix/store
    # REQUIRES: nixos-rebuild --impure
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
      };
    };

  };
}
