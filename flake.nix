{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05"; # TODO: "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    # TODO: unpin once codex builds on nixos-unstable again (aws-lc-sys: AWS_LC_SYS_USE_SYSTEM without system AWS-LC)
    nixpkgs-codex.url = "github:NixOS/nixpkgs/4975466d324710c576dc11ad614684e6bd8cad8e"; # codex 0.156.1
    nixos-hardware.url = "github:NixOS/nixos-hardware/master"; # TODO: "github:NixOS/nixos-hardware";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05"; # TODO: "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, nixos-hardware, home-manager, ... } @ inputs:
    let
      myBaseConfig =
        {
          hostName = "f13";
          userName = "m00k";
          userEmail = "christian.bican@gmail.com";
          system = "x86_64-linux";
          systemStateVersion = "23.11";
        };
      # TODO: extract to lib
      myMkHome = myConfig:
        let
          # Define it here so both NixOS and Home Manager can see it
          pkgs-unstable = import nixpkgs-unstable {
            inherit (myConfig) system;
            config = {
              allowUnfree = true;
            };
          };
        in
        {
          ${myConfig.hostName} =
            nixpkgs.lib.nixosSystem
              {
                inherit (myConfig) system;
                specialArgs = {
                  inherit inputs;
                  inherit myConfig;
                  inherit pkgs-unstable;
                };
                modules = with myConfig; [
                  ./system/configuration.nix
                  ./system/packages.nix
                  ./hosts/${hostName}/configuration.ext.nix
                  ./hosts/${hostName}/hardware-configuration.nix
                  # https://nixos-and-flakes.thiscute.world/nixos-with-flakes/start-using-home-manager
                  home-manager.nixosModules.home-manager
                  {
                    home-manager.useGlobalPkgs = true;
                    home-manager.useUserPackages = true;
                    home-manager.users.${userName} = import ./users/${userName}.nix;
                    home-manager.extraSpecialArgs = {
                      inherit inputs;
                      inherit myConfig;
                      inherit pkgs-unstable;
                    };
                  }
                ];
              };
        };
    in
    {
      nixosConfigurations =
        myMkHome
          (myBaseConfig)
        //
        myMkHome
          (myBaseConfig // {
            userName = "jelly";
            hostName = "flixn";
          })
        //
        myMkHome
          (myBaseConfig // {
            userName = "christian";
            userEmail = "christian.bican@marktguru.com";
            hostName = "worxn";
            systemStateVersion = "24.05";
          });
    };
}
