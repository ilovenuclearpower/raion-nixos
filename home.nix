{ config, pkgs, inputs, ... }:
let 
unstable = inputs.nixpkgs-unstable.legacyPackages.${pkgs.system};
in
{
  imports = [
  ./home/programs/nvim.nix  # Use simplified nixvim config
  ./home/programs/ncspot.nix
  ./home/desktop/hyprland.nix
  ./home/desktop/hyprpanel.nix
  ./home/development.nix
  ./home/theme.nix
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
  

  # User packages
  home.packages = with pkgs; [
    # Wayland clipboard utilities
    wl-clipboard
    
    # Text editor
    # Additional utilities
    neofetch
    tree
    tofi
    home-manager

    # Icon themes for hyprpanel
    papirus-icon-theme      # Sharp, clean icons
    adwaita-icon-theme      # Good fallback coverage
    hicolor-icon-theme      # Essential fallback
    tela-icon-theme         # Modern geometric design
    nerd-fonts.iosevka
    discordo



    # Idle and screen lock management (compatible with SDDM)
    hypridle
    hyprlock
    qutebrowser-qt5


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
      font = "monospace";
      background-color = "#1B1D1E";
      border-color = "#F92672";
      text-color = "#F8F8F2";
      prompt-color = "#F92672";
      placeholder-color = "#DEDEDE";
      input-color = "#F8F8F2";
      default-result-color = "#F8F8F2";
      selection-color = "#F92672";
    };
  };

  # git configuration
  programs.git = {
    enable = true;
    userName = "hik";
    userEmail = "hik@aboveaverage.space";
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
          timeout = 150;  # 2.5 minutes
          on-timeout = "brightnessctl -s set 10";
          on-resume = "brightnessctl -r";
        }
        {
          timeout = 300;  # 5 minutes  
          on-timeout = "loginctl lock-session";
        }
        {
          timeout = 380;  # 6.3 minutes
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
        {
          timeout = 1800; # 30 minutes
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

      background = [
        {
          path = "~/Pictures/wallpapers/rainbowumbrella.png";
        }
      ];

      input-field = [
        {
          size = "200, 50";
          position = "0, -200";
          monitor = "";
          dots_center = true;
          fade_on_empty = false;
          font_color = "rgb(255, 255, 255)";
          inner_color = "rgba(150, 50, 200, 0.3)";
          outer_color = "rgba(200, 100, 180, 0.6)";
          outline_thickness = 3;
          placeholder_text = "Password...";
          shadow_passes = 2;
        }
      ];

      label = [
        {
          monitor = "";
          text = "Hi $USER";
          color = "rgb(200, 200, 200)";
          font_size = 55;
          font_family = "Noto Sans";
          position = "0, 160";
          halign = "center";
          valign = "center";
        }
        {
          monitor = "";
          text = "$TIME";
          color = "rgb(200, 200, 200)";
          font_size = 90;
          font_family = "Noto Sans";
          position = "0, 0";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };
}
