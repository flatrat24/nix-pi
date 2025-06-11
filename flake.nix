{
  description = "NixOS Image for RaspPi 4";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nvf.url = "github:notashelf/nvf";
    neovim-config = {
      url = "github:flatrat24/neovim";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nvf.follows = "nvf";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ... } @ inputs: let
    system = "aarch64-linux";
    host = "pi";
    adminUser = "admin";
  in {
    nixosConfigurations.${host} = nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs;
        inherit system;
        inherit host;
        inherit adminUser;
      };
      modules = [
        ./configuration.nix
        inputs.nixos-hardware.nixosModules.raspberry-pi-4
        inputs.home-manager.nixosModules.home-manager
        {
          home-manager = {
            users.${adminUser} = import ./home.nix;
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = {
              inherit inputs;
              inherit system;
              inherit host;
              inherit adminUser;
            };
          };
        }
      ];
    };
  };
}
