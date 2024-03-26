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
      myConfig = {
        userName = "m00k";
        userEmail = "christian.bican@gmail.com";
        hostName = "f13";
        system = "x86_64-linux";
      };
      pkgs = import nixpkgs {
        inherit (myConfig) system;
        config.allowUnfree = true;
      };
    in
    {
      nixosConfigurations = {
        ${myConfig.hostName} = nixpkgs.lib.nixosSystem {
          inherit (myConfig) system;
          specialArgs = {
            inherit inputs;
            inherit myConfig;
          };
          modules = [
            ./system/configuration.nix
            ./hosts/${myConfig.hostName}/configuration.ext.nix
            ./hosts/${myConfig.hostName}/hardware-configuration.nix
            ./hosts/${myConfig.hostName}/hardware-configuration.ext.nix
            # https://github.com/NixOS/nixos-hardware/blob/master/README.md#using-nix-flakes-support
            nixos-hardware.nixosModules.framework-13-7040-amd
            # https://nixos-and-flakes.thiscute.world/nixos-with-flakes/start-using-home-manager
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.${myConfig.userName} = import ./users/${myConfig.userName}.nix;
              home-manager.extraSpecialArgs = {
                inherit inputs;
                inherit myConfig;
              };
            }
          ];
        };
      };
    };
}
