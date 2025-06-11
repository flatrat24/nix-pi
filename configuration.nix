{ pkgs, lib, inputs, system, ... }: {
  imports = [
    ./hardware-configuration.nix
  ];

  ##===================================================##
  ##=== TTY ===========================================##
  console = {
    font = "IBM Plex Serif";
    packages = with pkgs; [ ibm-plex ];
    keyMap = "us";
    colors = [
      "212337" # base00
      "F16C75" # base01
      "C0C95F" # base02
      "37F499" # base03
      "10A1BD" # base04
      "A48CF2" # base05
      "04D1F9" # base06
      "EBFAFA" # base07
      "212337" # base08
      "F0313E" # base09
      "F1FC79" # base10
      "00FA82" # base11
      "39DDFD" # base12
      "A48CF2" # base13
      "49EDFF" # base14
      "EBFAFA" # base15
    ];
  };
  ##=== END TTY =======================================##
  ##===================================================##

  ##===================================================##
  ##=== JELLYFIN ======================================##
  services.jellyfin = {
    enable = true;
    user = "admin";
  };
  environment.systemPackages = with pkgs; [
    wireguard-tools

    jellyfin
    jellyfin-web
    jellyfin-ffmpeg
    
    inputs.neovim-config.packages.${system}.default
  ];
  ##=== END JELLYFIN ==================================##
  ##===================================================##

  ##===================================================##
  ##=== ZSH ===========================================##
  users.defaultUserShell = pkgs.zsh;
  programs.zsh = {
    enable = true;
  };
  environment.variables = {
    SHELL = "zsh";
  };
  ##=== END ZSH =======================================##
  ##===================================================##

  ##===================================================##
  ##=== BOOTLOADER ====================================##
  boot = {
    loader.grub.enable = false;
    loader.generic-extlinux-compatible.enable = true;
  };
  ##=== END BOOTLOADER ================================##
  ##===================================================##
  
  ##===================================================##
  ##=== NETWORKING ====================================##
  networking = {
    hostName = "pi";
    networkmanager.enable = true;
    firewall = {
      enable = true;
      allowedUDPPorts = [ ];
    };
    ##=== Static IP (not on eduroam)
    defaultGateway = {
      address = "192.168.223.184";
      interface = "wlan0";
    };
    nameservers = [ "192.168.223.184" ];
    interfaces = {
      wlan0.ipv4.addresses = [
        {
          address = "192.168.223.184";
          prefixLength = 28;
        }
      ];
    };
    ##=== End Static IP
  };
  ##=== END NETWORKING ================================##
  ##===================================================##
  
  ##===================================================##
  ##=== ADMIN USER ====================================##
  users.users.admin = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ]; # Enable ‘sudo’ for the user.
    hashedPassword = "$y$j9T$fCvDlybBxH66IEzSdswzQ0$RUdso7st0Z17Jf1vDRGzmImP8Z2KI2N7nV5RPyW1qo."; # generate with `mkpasswd`
  };
  ##=== END ADMIN USER ================================##
  ##===================================================##

  ##===================================================##
  ##=== SSH ===========================================##
  services.openssh = {
    enable = true; # Enable the OpenSSH daemon.
    ports = [ 22 ];
    settings = {
      PasswordAuthentication = true;
      AllowUsers = null; # Allows all users by default. Can be [ "user1" "user2" ]
      UseDns = true;
      X11Forwarding = false;
      PermitRootLogin = "prohibit-password"; # "yes", "without-password", "prohibit-password", "forced-commands-only", "no"
    };
  };
  networking.firewall.allowedTCPPorts = [ 22 ];
  ##=== END SSH =======================================##
  ##===================================================##

  ##===================================================##
  ##=== MISCELLANEOUS =================================##
  hardware.enableAllHardware = lib.mkForce false;
  # not sure what this does

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  # enables flakes

  nix.settings.trusted-users = [ "admin" ];
  # this allows you to run `nixos-rebuild --target-host admin@this-machine` from
  # a different host. not used in this tutorial, but handy later.

  environment.variables = {
    EDITOR = "neovim";
  };
  # neovim as default editor

  system.stateVersion = "25.05"; # NEVER CHANGE THIS
  ##=== END MISCELLANEOUS =============================##
  ##===================================================##

}
