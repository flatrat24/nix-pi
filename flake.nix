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
    nvim = neovim-config.packages.${system}.default;
  in {
    nixosConfigurations."pi" = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {
        inputs = inputs;
        neovim-config = neovim-config;
      };
      modules = [
        ./configuration.nix
        nixos-hardware.nixosModules.raspberry-pi-4
        {
          environment.systemPackages = [
            nvim
          ];
        }
      ];
    };
  };
}
