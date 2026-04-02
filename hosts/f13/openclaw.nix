{ config, pkgs, pkgs-unstable, lib, myConfig, ... }:

let
  cfg = config.services.openclaw;
  workspacePath = "/var/lib/openclaw/workspace";
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
          model = "gemini-flash-lite-latest";
        };
      };
    };

    # Copy the secrets file into /etc/openclaw/openclaw-secrets
    # NOTE: This makes the file world-readable in /nix/store
    # REQUIRES: nixos-rebuild --impure
    environment.etc."openclaw/openclaw-secrets".source = "/home/${myConfig.userName}/workspace/nixos/.secrets/openclaw-secrets";

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

        # --- Advanced Hardening & Folder Restriction ---

        # 1. Start with a completely empty filesystem view
        ProtectSystem = "strict";
        ProtectHome = "tmpfs"; # Hides /home entirely, even from the 'openclaw' user

        # 2. Grant access ONLY to specific paths
        StateDirectory = "openclaw"; # Creates and grants RW to /var/lib/openclaw
        ReadWritePaths = [
          workspacePath
          downloadsPath
        ];

        # 3. Necessary for the binary to run and make HTTPS requests
        BindReadOnlyPaths = [
          "/etc/resolv.conf" # DNS
          "/etc/ssl/certs" # SSL for API calls
          "/etc/static/openclaw" # The config and secrets we created
          "/nix/store" # The read-only Nix store
        ];

        # Poke a hole in the tmpfs /home for the Downloads folder
        BindPaths = [
          downloadsPath
        ];

        # 4. Kernel & Privilege restrictions
        NoNewPrivileges = true;
        CapabilityBoundingSet = ""; # No root-like capabilities
        RestrictAddressFamilies = [ "AF_INET" "AF_INET6" "AF_UNIX" ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        MemoryDenyWriteExecute = true;
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
