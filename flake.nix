{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixos-hardware, home-manager, ... }@attrs:
    let
      userName = "m00k"; # TODO
      hostName = "f13"; # TODO
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {
      nixosConfigurations = {
        ${hostName} = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = attrs;
          modules = [
            # https://github.com/NixOS/nixos-hardware/blob/master/README.md#using-nix-flakes-support
            nixos-hardware.nixosModules.framework-13-7040-amd
            ./configuration.nix
            # https://nixos-and-flakes.thiscute.world/nixos-with-flakes/start-using-home-manager
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.m00k = import ./home.nix;
            }
          ];
        };
      };
    };
}
