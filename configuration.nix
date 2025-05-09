# https://blog.janissary.xyz/posts/nixos-install-custom-image
# https://github.com/lucernae/nixos-pi
# https://rbf.dev/blog/2020/05/custom-nixos-build-for-raspberry-pis/#nix-packages-and-image-configuration
# https://nixos.wiki/wiki/NixOS_on_ARM#Compiling_through_QEMU.2Fkvm

{ pkgs, neovim-config, system, inputs, ... }: {
  imports = [
    ./hardware-configuration.nix
  ];

  # allows the use of flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  boot = {
    # Use the extlinux boot loader. (NixOS wants to enable GRUB by default)
    loader.grub.enable = false;
    # Enables the generation of /boot/extlinux/extlinux.conf
    loader.generic-extlinux-compatible.enable = true;
  };

  # networking config. important for ssh!
  networking = {
    hostName = "pi";

    networkmanager.enable = true;

    firewall = {
      enable = true;
      allowedTCPPorts = [ ];
      allowedUDPPorts = [ ];
    };
  };

  # the user account on the machine
  users.users.admin = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    hashedPassword = "$y$j9T$fCvDlybBxH66IEzSdswzQ0$RUdso7st0Z17Jf1vDRGzmImP8Z2KI2N7nV5RPyW1qo.";
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # I use neovim as my text editor, replace with whatever you like
  environment.systemPackages = with pkgs; [
    # neovim
    wget
    inputs.neovim-config.defaultPackage
  ];

  # this allows you to run `nixos-rebuild --target-host admin@this-machine` from
  # a different host. not used in this tutorial, but handy later.
  nix.settings.trusted-users = [ "admin" ];

  # ergonomics, just in case I need to ssh into
  programs.zsh.enable = true;
  environment.variables = {
    SHELL = "zsh";
    EDITOR = "neovim";
  };

  system.stateVersion = "25.05"; # NEVER CHANGE THIS
}
