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
      baseConfig = {
        userName = "m00k";
        userEmail = "christian.bican@gmail.com";
        hostName = "nixos";
        system = "x86_64-linux";
      };
      f13Config = baseConfig // {
        hostName = "f13";
      };
      plexnConfig = f13Config // {
        userName = "media";
        hostName = "plexn";
      };
      pkgs = import nixpkgs {
        inherit (f13Config) system;
        config.allowUnfree = true;
      };
    in
    {
      nixosConfigurations = {
        ${f13Config.hostName} = nixpkgs.lib.nixosSystem {
          inherit (f13Config) system;
          specialArgs = {
            inherit inputs;
            myConfig = f13Config;
          };
          modules = [
            ./system/configuration.nix
            ./hosts/${f13Config.hostName}/configuration.ext.nix
            ./hosts/${f13Config.hostName}/hardware-configuration.nix
            ./hosts/${f13Config.hostName}/hardware-configuration.ext.nix
            # https://github.com/NixOS/nixos-hardware/blob/master/README.md#using-nix-flakes-support
            nixos-hardware.nixosModules.framework-13-7040-amd
            # https://nixos-and-flakes.thiscute.world/nixos-with-flakes/start-using-home-manager
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.${f13Config.userName} = import ./users/${f13Config.userName}.nix;
              home-manager.extraSpecialArgs = {
                inherit inputs;
                myConfig = f13Config;
              };
            }
          ];
        };
        ${plexnConfig.hostName} = nixpkgs.lib.nixosSystem {
          inherit (plexnConfig) system;
          specialArgs = {
            inherit inputs;
            myConfig = plexnConfig;
          };
          modules = [
            ./system/configuration.nix
            ./hosts/${f13Config.hostName}/configuration.ext.nix
            ./hosts/${plexnConfig.hostName}/hardware-configuration.nix
            # https://github.com/NixOS/nixos-hardware/blob/master/README.md#using-nix-flakes-support
            nixos-hardware.nixosModules.framework-13-7040-amd
            # https://nixos-and-flakes.thiscute.world/nixos-with-flakes/start-using-home-manager
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.${plexnConfig.userName} = import ./users/${plexnConfig.userName}.nix;
              home-manager.extraSpecialArgs = {
                inherit inputs;
                myConfig = plexnConfig;
              };
            }
          ];
        };
      };
    };
}
