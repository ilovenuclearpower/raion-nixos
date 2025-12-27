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
  ./home/programs/comfyui.nix
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

  # Ensure systemd user environment is updated with Home Manager PATH
  systemd.user.sessionVariables = config.home.sessionVariables;



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
  

  # Create custom desktop entry for NixVim
  xdg.desktopEntries.nixvim = {
    name = "NixVim";
    genericName = "Text Editor";
    comment = "Edit text files with NixVim configuration";
    exec = "kitty nvim %F";
    terminal = false;
    icon = "nvim";
    type = "Application";
    categories = [ "Utility" "TextEditor" "Development" ];
    mimeType = [
      # General text files
      "text/english"
      "text/plain"
      "text/x-makefile"
      
      # C/C++ files
      "text/x-c++hdr"
      "text/x-c++src" 
      "text/x-chdr"
      "text/x-csrc"
      "text/x-c"
      "text/x-c++"
      
      # Unity and .NET files
      "text/x-csharp"
      "application/x-csharp"
      
      # Web development
      "text/html"
      "text/css"
      "text/javascript"
      "application/javascript"
      "application/json"
      "text/xml"
      
      # Configuration files
      "text/x-yaml"
      "application/x-yaml"
      "text/x-toml"
      "application/x-toml"
      
      # Documentation
      "text/markdown"
      "text/x-markdown"
      
      # Python
      "text/x-python"
      "application/x-python"
      
      # Shell scripts
      "application/x-shellscript"
      "text/x-shellscript"
      
      # Other languages
      "text/x-java"
      "text/x-moc"
      "text/x-pascal"
      "text/x-tcl"
      "text/x-tex"
      "text/x-rust"
      "text/x-go"
      "text/x-lua"
    ];
  };

  # Default applications for file types
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      # C# files (Unity scripts)
      "text/x-csharp" = [ "nixvim.desktop" ];
      "application/x-csharp" = [ "nixvim.desktop" ];
      
      # Text and configuration files
      "text/plain" = [ "nixvim.desktop" ];
      "text/markdown" = [ "nixvim.desktop" ];
      "text/x-markdown" = [ "nixvim.desktop" ];
      
      # Web development
      "text/html" = [ "nixvim.desktop" ];
      "text/css" = [ "nixvim.desktop" ];
      "text/javascript" = [ "nixvim.desktop" ];
      "application/javascript" = [ "nixvim.desktop" ];
      "application/json" = [ "nixvim.desktop" ];
      "text/xml" = [ "nixvim.desktop" ];
      
      # Configuration files
      "text/x-yaml" = [ "nixvim.desktop" ];
      "application/x-yaml" = [ "nixvim.desktop" ];
      "text/x-toml" = [ "nixvim.desktop" ];
      "application/x-toml" = [ "nixvim.desktop" ];
      
      # Programming languages
      "text/x-python" = [ "nixvim.desktop" ];
      "application/x-python" = [ "nixvim.desktop" ];
      "text/x-c" = [ "nixvim.desktop" ];
      "text/x-c++" = [ "nixvim.desktop" ];
      "text/x-c++src" = [ "nixvim.desktop" ];
      "text/x-c++hdr" = [ "nixvim.desktop" ];
      "text/x-chdr" = [ "nixvim.desktop" ];
      "text/x-csrc" = [ "nixvim.desktop" ];
      "text/x-java" = [ "nixvim.desktop" ];
      "text/x-rust" = [ "nixvim.desktop" ];
      "text/x-go" = [ "nixvim.desktop" ];
      "text/x-lua" = [ "nixvim.desktop" ];
      
      # Shell scripts
      "application/x-shellscript" = [ "nixvim.desktop" ];
      "text/x-shellscript" = [ "nixvim.desktop" ];
    };
  };

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

# Enable comfyui service
  services.comfyui = { 
    enable = true;
    port = 8188;
  }

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
