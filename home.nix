{ pkgs, adminUser, ... }:
let
  aliases = {
    "g"    = "git";
    "sudo" = "sudo ";
    ".."   = "cd ..";
    "c"    = "clear";
    "q"    = "exit";
    "ls"   = "eza --group-directories-first --hyperlink";
  };
in {
  home.username = "${adminUser}";
  home.homeDirectory = "/home/${adminUser}";

  ##===================================================##
  ##=== PROGRAMS ======================================##
  home.packages = with pkgs; [
    #- Archives -#
    zip
    xz
    unzip
    p7zip

    #- Torrents -#
    transmission_4

    #- Shell -#
    starship

    #- Utils -#
    bat      
    jq
    eza
    fd
    fzf
    ripgrep
    moreutils
    delta
    du-dust
    dua
    ripgrep-all

    #- System/Network Monitoring -#
    bottom
    gping

    #- Other -#
    wget
    git
    gcc
    zstd
    magic-wormhole
  ];

  ##===================================================##
  ##=== ZSH ===========================================##
  programs.zsh = {
    enable = true;
    shellAliases = aliases;
    history = {
      save = 5000;
      size = 5000;
      path = "$HOME/.zsh_history";
      share = true;
      ignoreDups = true;
      ignoreSpace = true;
      ignoreAllDups = true;
    };
    enableCompletion = true;
    autosuggestion = {
      enable = true;
    };
    syntaxHighlighting = {
      enable = true;
    };
    plugins = [
      {
        name = "fzf-tab";
        src = pkgs.fetchFromGitHub {
          "owner" = "aloxaf";
          "repo"  = "fzf-tab";
          "rev"   = "6aced3f35def61c5edf9d790e945e8bb4fe7b305";
          "hash"  = "sha256-EWMeslDgs/DWVaDdI9oAS46hfZtp4LHTRY8TclKTNK8=";
        };
      }
    ];
    dotDir = ".config/zsh";
    initExtra = ''
      zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
      eval "$(starship init zsh)"
      function set_keybinds() {
        bindkey '^k' up-line-or-history
        bindkey '^j' down-line-or-history
        bindkey '^f' autosuggest-accept
        bindkey '^[w' kill-region
      }
      add-zsh-hook precmd set_keybinds
    '';
  };
  home.file = { ##=== Starship Prompt Config File
    ".config/starship.toml" = {
      source = ./sources/starship.toml;
      executable = false;
      recursive = false;
    };
  };

  ##===================================================##
  ##=== TRANSMISSION ==================================##

  ##===================================================##
  ##=== END TRANSMISSION ==============================##

  ##===================================================##
  ##=== GIT ===========================================##
  programs.git = {
    enable = true;
    userName = "Chloe Anthony";
    userEmail = "ethan.anthony@du.edu";
    delta.enable = true;
    extraConfig = {
      init.defaultBranch = "main";
    };
  };

  home.stateVersion = "25.05"; # NEVER CHANGE THIS
}
