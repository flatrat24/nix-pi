{ pkgs, lib, inputs, system, neovim-config, ... }: {
  imports = [
    ./hardware-configuration.nix
  ];

  ##--- Jellyfin ---##
  services.jellyfin = {
    enable = true;
    user = "admin";
  };
  environment.systemPackages = with pkgs; [
    jellyfin
    jellyfin-web
    jellyfin-ffmpeg
  ];

  ##--- ZSH Config ---##
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableLsColors = true;
    # shellAliases = {
    #   
    # };
  };
  environment.variables = {
    SHELL = "zsh";
  };

  hardware.enableAllHardware = lib.mkForce false;
  
  boot = {
    # Use the extlinux boot loader. (NixOS wants to enable GRUB by default)
    loader.grub.enable = false;
    # Enables the generation of /boot/extlinux/extlinux.conf
    loader.generic-extlinux-compatible.enable = true;
  };
  
  networking = {
    hostName = "pi";

    networkmanager.enable = true;

    # firewall = {
    #   enable = true;
    #   allowedTCPPorts = [ ];
    #   allowedUDPPorts = [ ];
    # };
  };
  
  # the user account on the machine
  users.users.admin = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ]; # Enable ‘sudo’ for the user.
    hashedPassword = "$y$j9T$fCvDlybBxH66IEzSdswzQ0$RUdso7st0Z17Jf1vDRGzmImP8Z2KI2N7nV5RPyW1qo."; # generate with `mkpasswd`
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # allows the use of flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # this allows you to run `nixos-rebuild --target-host admin@this-machine` from
  # a different host. not used in this tutorial, but handy later.
  nix.settings.trusted-users = [ "admin" ];

  # ergonomics, just in case I need to ssh into
  environment.variables = {
    EDITOR = "neovim";
  };

  system.stateVersion = "25.05"; # NEVER CHANGE THIS
}
