{ config, lib, pkgs, pkgs-unstable, myConfig, ... }:

let
  # Read by opencode at runtime via its `{file:...}` placeholder, so the key
  # never enters the nix store (unlike builtins.readFile). Same idea as
  # wireguard's privateKeyFile. File content: the bare key, nothing else.
  openRouterKeyFile = "/home/${myConfig.userName}/workspace/nixos/.secrets/openRouter.api.key.nix";
in
{
  # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.opencode.enable
  # config per https://marktguru.monday.com/docs/5103250375 (OpenRouter + GLM 5.3 Flash)
  # https://opencode.ai/docs/config/ (variable substitution: {env:...}, {file:...})
  programs.opencode = {
    enable = true;
    package = pkgs-unstable.opencode;
    settings = {
      model = "openrouter/z-ai/glm-5.3-flash";
      small_model = "openrouter/z-ai/glm-5.3-flash";
      provider.openrouter = {
        options.apiKey = "{file:${openRouterKeyFile}}";
        whitelist = [ "z-ai/glm-5.3-flash" ];
        models."z-ai/glm-5.3-flash".options.provider = {
          # failover list, not a rotation; order set on 2026-09-03
          order = [ "baseten/fp8" "deepinfra/fp8" "reka/fp8" "novita/fp8" ];
          allow_fallbacks = false;
        };
      };
    };
  };
}
