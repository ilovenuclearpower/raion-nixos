{ config, pkgs, inputs, ... }:
let 
unstable = inputs.nixpkgs-unstable.legacyPackages.${pkgs.system};
in
{
  nixpkgs.config.allowUnfree = true;
  imports = [
  ./home/programs/nvim.nix  # Use simplified nixvim config
  ./home/programs/ncspot.nix
  ./home/desktop/hyprland.nix
  ./home/desktop/waybar.nix
  ./home/development.nix
  ./home/theme.nix
  ./home/programs/imagemagick.nix
  ./home/programs/calibre.nix
  inputs.hyprcursor-phinger.homeManagerModules.hyprcursor-phinger
  ];
  # Home Manager needs a bit of information about you and the paths it should manage
  home.username = "hik";
  home.homeDirectory = "/home/hik";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.

  # Session variables for dark mode
  home.sessionVariables = {
    # GTK applications
    
    
    # General dark mode preference
    COLOR_SCHEME = "dark";
    
    # Electron applications
    ELECTRON_ENABLE_DARK_MODE = "1";
    
    # Terminal colors
    COLORTERM = "truecolor";
    
  };



  home.stateVersion = "25.05"; # Match your NixOS version

  # Disable the version check warning for now
  home.enableNixpkgsReleaseCheck = false;

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;
  programs.kitty.enable = true;
  programs.btop.enable = true;
  programs.rofi.enable = true;
  programs.hyprcursor-phinger.enable = true;
  programs.cava.enable = true;
  

  # User packages
  home.packages = with pkgs; [
    # Wayland clipboard utilities
    
    # Text editor
    # Additional utilities
    neofetch
    tree
    youtube-tui
    yt-dlp
    mpv
    home-manager
    (pkgs.callPackage ./packages/codecrafters {} )
    (pkgs.callPackage ./packages/stmps {} )

    # Icon themes for hyprpanel
    papirus-icon-theme      # Sharp, clean icons
    adwaita-icon-theme      # Good fallback coverage
    hicolor-icon-theme      # Essential fallback
    tela-icon-theme         # Modern geometric design
    nerd-fonts.iosevka
    discordo


    # Idle and screen lock management (compatible with SDDM)
    hypridle
    qutebrowser-qt5
    hyprcursor

    ## Terminal spreadsheet calculator
    sc-im


  ];

# tofi configuration
  programs.tofi = {
    enable = true;
    settings = {
      width = 100;
      height = 100;
      border-width = 0;
      outline-width = 0;
      padding-left = 35;
      padding-top = 35;
      result-spacing = 25;
      num-results = 5;
    };
  };

  # git configuration
  programs.git = {
    enable = true;
    userName = "hik";
    userEmail = "burrito@aboveaverage.space";
    
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
      core.editor = "nvim";
      diff.tool = "nvim";
      merge.tool = "nvim";
    };
    
    aliases = {
      st = "status";
      co = "checkout";
      br = "branch";
      ci = "commit";
      lg = "log --oneline --graph --decorate";
    };
  };

  # Shell configuration (optional)
  programs.bash = {
    enable = true;
    bashrcExtra = ''
      # Custom bash configuration
      export EDITOR=nvim
    '';
  };

  # Hypridle configuration for idle management
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        after_sleep_cmd = "hyprctl dispatch dpms on";
        before_sleep_cmd = "loginctl lock-session";
        ignore_dbus_inhibit = false;
        lock_cmd = "pidof hyprlock || hyprlock";
      };
      
      listener = [
        {
          timeout = 1200;  # 20 minutes  
          on-timeout = "loginctl lock-session";
        }
        {
          timeout = 1500;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on && brightnessctrl -r";
        }
        {
          timeout = 1800; # Almost an hour
          on-timeout = "systemctl suspend";
        }
      ];
    };
  };

  # Hyprlock configuration for screen locking
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        disable_loading_bar = true;
        grace = 30;
        hide_cursor = true;
        no_fade_in = false;
      };
    };
  };
}
