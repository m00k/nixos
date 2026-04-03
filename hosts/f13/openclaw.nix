{ config, pkgs, pkgs-unstable, lib, myConfig, ... }:

let
  cfg = config.services.openclaw;
  downloadsPath = "/home/${myConfig.userName}/Downloads";
  stateDir = "/var/lib/openclaw";
  myPython = pkgs.python3.withPackages (ps: with ps; [
    requests
    beautifulsoup4
  ]);
  pythonInterpreter = "${myPython}/bin/python3";

  easynewsSearchScriptContent = builtins.readFile ./easynews_search_script.py;
  easynewsSearchSkillContentTemplate = builtins.readFile ./easynews_search_skill.md;
  easynewsSearchSkillContent = lib.replaceStrings
    [ "@SCRIPT_PATH@" "@PYTHON_PATH@" ]
    [ "${easynewsSearchScript}" "${pythonInterpreter}" ]
    easynewsSearchSkillContentTemplate;

  # Create a derivation for the Python script so it lives in the Nix store
  easynewsSearchScript = pkgs.writeText "easynews_search_script.py" easynewsSearchScriptContent;
  easynewsSearchSkill = pkgs.writeText "SKILL.md" easynewsSearchSkillContent;

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

  # Create a single immutable directory containing both files
  easynewsSkillDir = pkgs.runCommand "openclaw-skill-easynews" { } ''
    mkdir -p $out
    cp ${easynewsSearchSkill} $out/SKILL.md
    cp ${easynewsSearchScript} $out/search_script.py
  '';
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
      # This gives OpenClaw a valid shell to interact with the host and its skills!
      shell = pkgs.bashInteractive;
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
      skills = {
        load = {
          extraDirs = [ "${stateDir}/skills" ];
        };
      };
      commands = {
        native = "auto";
        nativeSkills = "auto";
        restart = true;
        ownerDisplay = "raw";
      };
    };

    environment.etc."openclaw/openclaw-secrets".source = "/home/${myConfig.userName}/workspace/nixos/.secrets/openclaw-secrets";

    systemd.tmpfiles.rules = [
      # 1. Force remove any existing directory/debris first
      "R ${stateDir}/skills/easynews - - - - -"

      # 2. Create a symlink for the ENTIRE folder to the Nix Store
      # This makes the folder and its contents immutable to OpenClaw
      "L+ ${stateDir}/skills/easynews - - - - ${easynewsSkillDir}"
    ];

    systemd.services.openclaw = {
      description = "OpenClaw AI Gateway";
      after = [ "systemd-tmpfiles-setup.service" "network.target" ];
      wantedBy = [ "multi-user.target" ];

      path = with pkgs; [
        bash
        coreutils
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
        BindReadOnlyPaths = [ "/nix/store" ]; # Explicitly allow the agent to read the store

        ProtectSystem = "nodev"; # Less restrictive than "full", allows better store access
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
