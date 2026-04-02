{ config, pkgs, pkgs-unstable, lib, ... }:

let
  cfg = config.services.openclaw;
  workspacePath = "/var/lib/openclaw/workspace";
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

    # Write the config file (JSON format)
    environment.etc."openclaw/openclaw.json".text = builtins.toJSON {
      gateway = {
        bind = "127.0.0.1"; # Loopback only for security
        port = 18789;
        auth = {
          mode = "token";
          token = "\${OPENCLAW_GATEWAY_TOKEN}";
        };
        workspace = workspacePath;
      };
      agents = {
        defaults = {
          provider = "google";
          model = "gemini-1.5-flash-latest";
        };
      };
    };

    # Copy the secrets file into /etc/openclaw/openclaw-secrets
    # NOTE: This makes the file world-readable in /nix/store
    environment.etc."openclaw/openclaw-secrets".source = ../../.secrets/openclaw-secrets;

    # Secure Service Definition
    systemd.services.openclaw = {
      description = "OpenClaw AI Gateway";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        ExecStart = "${pkgs-unstable.openclaw}/bin/openclaw serve --config /etc/openclaw/openclaw.json";
        EnvironmentFile = "/etc/openclaw/openclaw-secrets";
        User = "openclaw";
        Group = "openclaw";

        # NixOS Hardening
        StateDirectory = "openclaw";
        ReadWritePaths = [ workspacePath ];
        ProtectSystem = "strict";
        ProtectHome = true;
        PrivateTmp = true;
      };
    };
  };
}
