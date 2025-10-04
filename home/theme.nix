{ config, pkgs, inputs, wallpaper, ... }:

{
  # Import Stylix home-manager module (using new module path)
  imports = [
    inputs.stylix.homeModules.stylix
  ];

  home.packages = with pkgs; [
    hyprcursor
    catppuccin-cursors
  ];

  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    name = "Catppuccin-Mocha-Sky";
    size = 24;
    package = pkgs.catppuccin-cursors.mochaSky;

    };
  xdg.configFile."hypr/hyprpaper.conf".text = ''
    # Preload wallpapers (add your wallpaper paths here)
    preload = ~/Pictures/wallpapers/rainbowumbrella.png
    preload = ~/Pictures/wallpapers/cyberpunkapartment.jpg
    
    # Set initial wallpaper for all monitors
    wallpaper = ,~/Pictures/wallpapers/rainbowumbrella.png
    
    # Enable splash text rendering
    splash = false
    
    # Enable ipc for hyprctl commands
    ipc = on
  '';
  # Wallpaper slideshow script
  home.file.".local/bin/wallpaper-slideshow.sh" = {
    text = ''
      #!/usr/bin/env bash
      
      WALLPAPER_DIR="$HOME/Pictures/wallpapers"
      INTERVAL=300  # 5 minutes in seconds
      
      # Function to get random wallpaper
      get_random_wallpaper() {
        find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" -o -name "*.webp" \) | shuf -n1
      }
      
      # Start hyprpaper if not running
      if ! pgrep -x "hyprpaper" > /dev/null; then
        hyprpaper &
        sleep 2
      fi
      
      # Main slideshow loop
      while true; do
        WALLPAPER=$(get_random_wallpaper)
        if [ -n "$WALLPAPER" ]; then
          # Preload the new wallpaper
          hyprctl hyprpaper preload "$WALLPAPER"
          # Set it as wallpaper for all monitors
          hyprctl hyprpaper wallpaper ",$WALLPAPER"
          echo "Changed wallpaper to: $WALLPAPER"
        fi
        sleep $INTERVAL
      done
    '';
    executable = true;
  }; # Systemd service for wallpaper slideshow
  systemd.user.services.wallpaper-slideshow = {
    Unit = {
      Description = "Hyprpaper wallpaper slideshow";
      After = [ "graphical-session.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${config.home.homeDirectory}/.local/bin/wallpaper-slideshow.sh";
      Restart = "always";
      RestartSec = "10";
      Environment = "PATH=${pkgs.hyprpaper}/bin:${pkgs.findutils}/bin:${pkgs.bash}/bin:${pkgs.bash}/bin:${pkgs.coreutils}/bin:${pkgs.hyprland}/bin";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  }; 
  # Minimal Stylix configuration
  stylix = {

    enable = true;
    
    # Disable auto-detection of targets
    autoEnable = false;
    image = wallpaper;
    polarity = "dark";
    
    # Minimal font configuration
    fonts = {
      monospace = {
        package = pkgs.jetbrains-mono;
        name = "JetBrains Mono";
      };
    };

    opacity = {
      applications = 0.85;
      desktop = 1.0;
      popups = 0.98;
      terminal = 0.85;

    };
    
    # ONLY enable GTK theming for now - nothing else
    targets = {
      kitty.enable = true;
      gtk.enable = true;
      firefox.enable = true;
      btop.enable = true;
      qt.enable = true;
      qutebrowser.enable = true;
      hyprland.enable = true;
      nixvim = {
        enable = true;
        transparentBackground = {
          main = true;
          numberLine = true;
          signColumn = true;
        };
      };
      neovim = {
        enable = true;
        transparentBackground = {
            main = true;
            numberLine = true;
            signColumn = true;
          };
    };
  };
};
}
