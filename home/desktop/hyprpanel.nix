{ config, pkgs, ... }:
{
  # Enable HyprPanel via built-in home-manager module
  programs.hyprpanel = {
    enable = true;
    
    
    # Don't assert notification daemons since we might use dunst
    dontAssertNotificationDaemons = true;
    
    # Explicitly enable systemd service
    systemd.enable = true;
    
    # Correct configuration structure that matches config.json format
    settings = {
      # Bar layouts - THIS is the correct path structure
      bar.layouts = {
        # Configure for monitor "0" (primary monitor)
        # Use "*" or specific monitor numbers like "0", "1", "2"
        "0" = {
          left = [
            "dashboard"
            "workspaces" 
            "windowtitle"
          ];
          middle = [
            "clock"  # This will now actually show clock in the middle
          ];
          right = [
            "volume"
            "network" 
            "bluetooth"
            "systray"
            "notifications"
          ];
        };
      };
      
      # Bar appearance settings
      bar.floating = false;  # Set to true for floating bar
      bar.position = "top";
      bar.layer = "overlay";
      
      # Bar spacing and padding
      bar.spacing = 8;
      bar.padding = 8;
      bar.margin = 0;
      
      # Launcher/Dashboard icon
      bar.launcher.icon = "";  # Arch icon, change if desired
      bar.launcher.autoDetectIcon = false;
      
      # Workspaces configuration
      bar.workspaces.show_icons = true;
      bar.workspaces.show_numbered = true;
      bar.workspaces.numbered_active_indicator = "highlight";
      bar.workspaces.workspaces = 10;
      bar.workspaces.spacing = 4;
      bar.workspaces.monochrome = false;
      bar.workspaces.hideUnoccupied = false;
      
      # Window title
      bar.windowtitle.label = true;
      bar.windowtitle.icon = true;
      bar.windowtitle.labelMaxLength = 80;
      
      # Media player module
      bar.media.show_active_only = true;
      bar.media.truncation = true;
      bar.media.truncation_size = 60;
      
      # Volume module
      bar.volume.label = true;
      bar.volume.raiseMaximumVolume = false;
      
      # Network module  
      bar.network.label = true;
      bar.network.truncation = true;
      bar.network.truncation_size = 25;
      
      # Bluetooth module
      bar.bluetooth.label = true;
      
      # Systray
      bar.systray.spacing = 8;
      
      # Clock module (in the bar itself)
      bar.clock.format = "%H:%M:%S";
      bar.clock.showIcon = true;
      bar.clock.showTime = true;
      bar.clock.icon = "";
      
      # Notifications
      bar.notifications.show_total = true;
      
      # Menu configurations
      menus.clock = {
        time = {
          military = true;
          hideSeconds = false;  # Show seconds in menu
        };
        weather = {
          enabled = false;  # Disable if no API key
          unit = "metric";
        };
      };
      
      menus.dashboard = {
        powermenu.avatar = {
          image = "";  # Path to avatar image if desired
          name = "User";
        };
        directories.enabled = true;
        directories.left.directory1 = {
          label = "󰚝  Documents";
          command = "bash -c 'xdg-open $HOME/Documents'";
        };
        directories.left.directory2 = {
          label = "󰚝  Downloads";
          command = "bash -c 'xdg-open $HOME/Downloads'";
        };
        directories.right.directory1 = {
          label = "󰚝  Config";
          command = "bash -c 'xdg-open $HOME/.config'";
        };
        directories.right.directory2 = {
          label = "󰚝  Projects";
          command = "bash -c 'xdg-open $HOME/Projects'";
        };
        stats.enable_gpu = true;
        
        shortcuts.left.shortcut1 = {
          icon = "󰀜";  # Browser/web icon
          tooltip = "Firefox";
          command = "firefox";
        };
        shortcuts.left.shortcut2 = {
          icon = "󰎆";  # Music/audio icon (for ncspot)
          tooltip = "ncspot";
          command = "kitty -e ncspot";
        };
        shortcuts.left.shortcut3 = {
          icon = "󰏗";  # Terminal icon
          tooltip = "Terminal";
          command = "kitty";
        };
        shortcuts.left.shortcut4 = {
          icon = "󰉋";  # Folder icon
          tooltip = "File Manager";
          command = "nautilus";
        };
        
        shortcuts.right.shortcut1 = {
          icon = "󰊗";  # Chart/stats icon (perfect for btop)
          tooltip = "System Monitor";
          command = "kitty -e btop";
        };
        shortcuts.right.shortcut2 = {
          icon = "󰈙";  # Text editor icon
          tooltip = "Text Editor";
          command = "kitty -e nvim";
        };
        shortcuts.right.shortcut3 = {
          icon = "󰒓";  # Settings/gear icon
          tooltip = "System Settings";
          command = "kitty -e sudo nixos-rebuild switch --flake /etc/nixos";
        };
        shortcuts.right.shortcut4 = {
          icon = "󰕾";  # Audio/volume icon
          tooltip = "Audio Control";
          command = "pavucontrol";
        };
      };
      
      
      # Theme configuration for sharp neon aesthetic  
      theme = {
        font = {
          name = config.stylix.fonts.sansSerif.name; 
          size = "18px";
        };

        button.default = {
          background = "#${config.lib.stylix.colors.base01}";
          text = "#${config.lib.stylix.colors.base05}";
        };

        notification = {
          background = "#${config.lib.stylix.colors.base01}";
          text = "#${config.lib.stylix.colors.base05}";
        };
        
        bar = {
          transparent = true;
          opacity = 95;
          background = "#${config.lib.stylix.colors.base00}";
          foreground = "#${config.lib.stylix.colors.base05}";

          
          # Sharp neon aesthetic
          menus_opacity = 0.95;
          
          buttons_opacity = 100;
          buttons_monochrome = false;
          buttons_y_margins = 0;
          buttons_spacing = 2;
          buttons_radius = 0;  # Sharp corners
          
          scaling = 100;
          outer_spacing = 4;
          
          # Border settings  
          border_width = 2;
          border_radius = 0;  # Sharp corners for neon look
          
          margin_top = 0;
          margin_bottom = 0;
          margin_sides = 0;
          
          padding = 6;
        };
      };
      
      # OSD settings
      osd.enable = true;
      osd.position = "top";
      osd.orientation = "horizontal";
      osd.duration = 2000;
      osd.radius = 0;  # Sharp corners
      osd.monitor = 0;
      osd.location = "center";
      
      # Notifications settings
      notifications.position = "top right";
      notifications.active_monitor = false;
      notifications.monitor = 0;
      notifications.timeout = 5000;
      notifications.cache_actions = true;
      
      # Wallpaper settings (if using swww)
      wallpaper.enable = false;
      
      # Custom styling to force neon colors
      customModules.updates = {
        pollingInterval = 1440000;
      };
    };
  };
  
  # Ensure hyprpanel starts after Hyprland
  systemd.user.services.hyprpanel = {
    Unit = {
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.hyprpanel}/bin/hyprpanel";
      Restart = "on-failure";
      RestartSec = 3;
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
