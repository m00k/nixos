{ config, pkgs, pkgs-unstable, lib, myConfig, ... }:

let
  cfg = config.services.openclaw;
  downloadsPath = "/home/${myConfig.userName}/Downloads";
  stateDir = "/var/lib/openclaw";

  easynewsSearchScriptContent = builtins.readFile ./easynews_search_script.py;
  easynewsSearchSkillContent = builtins.readFile ./easynews_search_skill.md;

  # Create a derivation for the Python script so it lives in the Nix store
  # This makes the script read-only and immutable.
  easynewsSearchScript = pkgs.writeText "easynews_search_script.py" easynewsSearchScriptContent;
  # Process the Markdown to point to the store path of the script
  # We use 'replaceStrings' to swap a placeholder in your MD with the real path.
  easynewsSearchSkill = lib.replaceStrings [ "@SCRIPT_PATH@" ] [ "${easynewsSearchScript}" ] easynewsSearchSkillContent;

  # Define the auth profile JSON
  googleApiKey = lib.removeSuffix "\n" (builtins.readFile "/home/${myConfig.userName}/workspace/nixos/.secrets/openclaw.google-api-key");
  # Define the auth profile JSON matching the wizard's output
  agentAuthProfile = builtins.toJSON {
    version = 1;
    profiles = {
      "google:default" = {
        type = "api_key";
        provider = "google";
        key = googleApiKey;
      };
    };
  };
in
{
  options.services.openclaw = {
    enable = lib.mkEnableOption "OpenClaw AI Gateway";
  };

  config = lib.mkIf cfg.enable {
    users.users.openclaw = {
      isSystemUser = true;
      group = "openclaw";
      home = stateDir;
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
          model = {
            primary = "google/gemini-flash-lite-latest";
          };
          models = {
            "google/gemini-flash-lite-latest" = { };
          };
          # Correct workspace directory mapping
          workspace = "${stateDir}";
        };
      };
      # This needs to be at the root level!
      commands = {
        native = "auto";
        nativeSkills = "auto";
        restart = true;
        ownerDisplay = "raw";
      };
    };

    environment.etc."openclaw/openclaw-secrets".source = "/home/${myConfig.userName}/workspace/nixos/.secrets/openclaw-secrets";

    systemd.tmpfiles.rules = [
      # 1. Ensure directories exist
      "d ${stateDir}/scripts 0750 openclaw openclaw -"
      "d ${stateDir}/skills 0750 openclaw openclaw -"
      "d ${stateDir}/agents/main/agent 0750 openclaw openclaw -"

      # 2. Force symlinks (L+) to the Nix Store versions of your files
      # This effectively "locks" the agent's logic to your current Nix generation.
      "L+ ${stateDir}/scripts/easynews_search_script.py - - - - ${easynewsSearchScript}"
      "L+ ${stateDir}/skills/easynews_search_skill.md - - - - ${easynewsSearchSkill}"
      "L+ ${stateDir}/agents/main/agent/auth-profiles.json - - - - ${pkgs.writeText "auth-profiles.json" agentAuthProfile}"
    ];

    systemd.services.openclaw = {
      description = "OpenClaw AI Gateway";
      after = [ "systemd-tmpfiles-setup.service" "network.target" ];
      wantedBy = [ "multi-user.target" ];

      path = with pkgs; [
        curl
        (python3.withPackages (ps: with ps; [ beautifulsoup4 requests ]))
      ];

      serviceConfig = {
        ExecStart = "${pkgs-unstable.openclaw}/bin/openclaw gateway";
        EnvironmentFile = "/etc/openclaw/openclaw-secrets";
        Environment = [
          "OPENCLAW_STATE_DIR=/var/lib/openclaw"
          "OPENCLAW_CONFIG_PATH=/etc/openclaw/openclaw.json"
        ];
        User = "openclaw";
        Group = "openclaw";
        ReadWritePaths = [ stateDir downloadsPath ];

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
