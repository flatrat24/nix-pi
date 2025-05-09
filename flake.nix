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
  };

  outputs = { self, nixpkgs, nixos-hardware, neovim-config, ... } @ inputs: let
    system = "aarch64-linux";
  in {
    nixosConfigurations."pi" = nixpkgs.lib.nixosSystem {
      specialArgs = {
        inputs = inputs;
        system = system;
        neovim-config = neovim-config;
      };
      modules = [
        ./configuration.nix
        nixos-hardware.nixosModules.raspberry-pi-4
      ];
    };
  };
}
