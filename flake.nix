{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  # TODO:
  # inputs = {
  #   nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  #   nixos-hardware.url = "github:NixOS/nixos-hardware";
  #   home-manager = {
  #     url = "github:nix-community/home-manager";
  #     inputs.nixpkgs.follows = "nixpkgs";
  #   };
  # };

  outputs = { self, nixpkgs, nixos-hardware, home-manager, ... }@inputs:
    let
      myConfigs =
        rec {
          base = {
            hostName = "nixos";
            userName = "m00k";
            userEmail = "christian.bican@gmail.com";
            system = "x86_64-linux";
          };
          f13 = base // {
            hostName = "f13";
          };
          plexn = base // {
            userName = "media";
            hostName = "plexn";
          };
        };
    in
    {
      nixosConfigurations =
        ((myConfig: {
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
                  ./hosts/${hostName}/hardware-configuration.ext.nix
                  # https://github.com/NixOS/nixos-hardware/blob/master/README.md#using-nix-flakes-support
                  nixos-hardware.nixosModules.framework-13-7040-amd
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
        }) myConfigs.f13)

        //

        ((myConfig: {
          ${myConfig.hostName} = nixpkgs.lib.nixosSystem {
            inherit (myConfig) system;
            specialArgs = {
              inherit inputs;
              inherit myConfig;
            };
            modules = with myConfig; [
              ./system/configuration.nix
              ./hosts/${hostName}/configuration.ext.nix
              ./hosts/${hostName}/hardware-configuration.nix
              home-manager.nixosModules.home-manager # TODO: de-duplicate
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
        }) myConfigs.plexn);
    };
}
