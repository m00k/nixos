{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11"; # TODO: "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master"; # TODO: "github:NixOS/nixos-hardware";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11"; # TODO: "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixos-hardware, home-manager, ... } @ inputs:
    let
      myBaseConfig =
        {
          hostName = "nixos";
          userName = "m00k";
          userEmail = "christian.bican@gmail.com";
          system = "x86_64-linux";
        };
      # TODO: extract to lib
      myMkHome = myConfig:
        {
          ${myConfig.hostName} =
            nixpkgs.lib.nixosSystem
              {
                inherit (myConfig) system;
                specialArgs = {
                  inherit inputs;
                  inherit myConfig;
                };
                modules = with myConfig; [
                  ./system/configuration.nix
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
                    };
                  }
                ];
              };
        };
    in
    {
      nixosConfigurations =
        myMkHome
          (myBaseConfig // {
            hostName = "f13";
          })
        //
        myMkHome
          (myBaseConfig // {
            userName = "media";
            hostName = "plexn";
          });
    };
}
