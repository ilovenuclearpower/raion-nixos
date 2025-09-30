{ config, pkgs, ... }:

{
  # HyprPanel is now built into home-manager, no need for imports
  
  # Enable HyprPanel via built-in home-manager module
  programs.hyprpanel = {
    enable = true;
    
    # Don't assert notification daemons since we might use dunst
    dontAssertNotificationDaemons = true;
    
    # Maximalist cyberpunk configuration for wide monitors
    settings = {
      # Panel layout optimized for wide displays
      layout = {
        "*" = {
          left = [
            "dashboard"
            "workspaces" 
            "windowtitle"
            "media"
          ];
          middle = [
            "clock"
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
      
      # Panel appearance - compact height for wide monitor
      panel = {
        height = 32;
        position = "top";
        # Fully transparent background - let objects show through
        backgroundColor = "rgba(0, 0, 0, 0.1)";
        borderRadius = 0;  # Sharp, no rounded corners
        margins = {
          top = 0;
          bottom = 0;
          left = 0;
          right = 0;
        };
        border = {
          width = 1;
          color = "rgba(0, 255, 136, 0.3)";  # Subtle neon green border
        };
      };
      
      # Cyberpunk color theme
      theme = {
        # Main neon colors
        primary = "#00ff88";      # Neon green
        secondary = "#ff0066";    # Hot pink  
        accent = "#0088ff";       # Cyber blue
        warning = "#ffaa00";      # Neon orange
        error = "#ff4040";        # Neon red
        success = "#00ff44";      # Bright green
        
        # Text colors
        textPrimary = "#ffffff";   # White
        textSecondary = "#cccccc"; # Light gray
        
        # Background colors
        background = "#0a0a0a";    # Dark
        surface = "#1a1a1a";       # Darker surface
      };
      
      # Module configurations for maximalist experience
      modules = {
        # Workspaces - key for wide monitor workflow
        workspaces = {
          showNumbered = true;
          showIcons = true;
          activeWorkspaceColor = "#00ff88";
          inactiveWorkspaceColor = "#333333";  # Higher contrast
          urgentWorkspaceColor = "#ff0066";
          spacing = 2;  # Tighter spacing
          workspaceCount = 10;  # Utilize wide screen real estate
          borderRadius = 2;
          activeBorderWidth = 2;
          activeBorderColor = "#00ff88";
          iconTheme = "Papirus-Dark";
        };
        
        # Clock - central cyberpunk element
        clock = {
          format = "%H:%M:%S";     # Include seconds for cyberpunk feel
          dateFormat = "%Y-%m-%d"; # ISO date format
          showDate = true;
          color = "#00ff88";
          fontSize = 14;
          fontWeight = "bold";
          backgroundColor = "rgba(0, 255, 136, 0.1)";
          borderRadius = 2;
          padding = 8;
          border = {
            width = 1;
            color = "rgba(0, 255, 136, 0.5)";
          };
        };
        
        # Volume with visual feedback
        volume = {
          showPercentage = true;
          color = "#0088ff";
          mutedColor = "#ff4040";
          showIcon = true;
          iconTheme = "Papirus-Dark";  # Use sharp icon theme
          backgroundColor = "rgba(0, 136, 255, 0.15)";
          borderRadius = 2;  # Minimal rounding
        };
        
        # Network with speed info for maximalist data
        network = {
          showSpeed = true;         # Show network speeds
          showSignalStrength = true;
          color = "#ff0066";
          disconnectedColor = "#666666";
          maxLength = 30;          # Use wide screen space
        };
        
        # Bluetooth status
        bluetooth = {
          showStatus = true;
          showConnectedDevices = true;
          color = "#aa00ff";       # Purple
          maxLength = 25;
          iconTheme = "Papirus-Dark";
          backgroundColor = "rgba(170, 0, 255, 0.15)";
          borderRadius = 2;
        };
        
        # Media player - important for cyberpunk aesthetic
        media = {
          showArtwork = true;
          showControls = true;
          maxLength = 60;          # Take advantage of wide monitor
          color = "#ffaa00";
          showProgress = true;
          iconTheme = "Papirus-Dark";
          backgroundColor = "rgba(255, 170, 0, 0.15)";
          borderRadius = 2;
          fontWeight = "bold";
        };
        
        # System tray
        systray = {
          spacing = 2;  # Tighter spacing for sharp look
          iconSize = 20;  # Slightly larger for better visibility
          showTooltips = true;
          iconTheme = "Papirus-Dark";
          backgroundColor = "rgba(255, 255, 255, 0.05)";
          borderRadius = 2;
        };
        
        # Notifications
        notifications = {
          showCount = true;
          color = "#ff6600";
          maxNotifications = 5;    # More notifications on wide screen
          iconTheme = "Papirus-Dark";
          backgroundColor = "rgba(255, 102, 0, 0.15)";
          borderRadius = 2;
          urgentColor = "#ff0000";
          urgentBackgroundColor = "rgba(255, 0, 0, 0.2)";
        };
        
        # Dashboard/launcher
        dashboard = {
          color = "#00ffff";       # Cyan
          showIcon = true;
          iconTheme = "Papirus-Dark";
          backgroundColor = "rgba(0, 255, 255, 0.15)";
          borderRadius = 2;
          iconSize = 20;
        };
        
        # Window title - utilize horizontal space
        windowtitle = {
          maxLength = 80;          # Wide monitor advantage
          color = "#ffffff";
          showIcon = true;
          truncate = "end";
        };
        
        # Battery (if applicable)
        battery = {
          showPercentage = true;
          showTime = true;
          color = "#00ff88";
          lowBatteryColor = "#ff4040";
          chargingColor = "#ffaa00";
        };
      };
      
      # Enable animations for cyberpunk feel
      animations = {
        enabled = true;
        duration = 200;
        curve = "ease-out";
      };
      
      # Maximalist features
      features = {
        showTooltips = true;
        autoHide = false;        # Always visible on wide monitor
        clickThrough = false;
        layer = "top";
        exclusive = true;        # Reserve space
      };
      
      # OSD (On-Screen Display) settings
      osd = {
        enable = true;
        position = "center";
        timeout = 2000;
        backgroundColor = "rgba(10, 10, 10, 0.9)";
        textColor = "#00ff88";
      };
    };
  };
  
  # Ensure HyprPanel starts with Hyprland
  wayland.windowManager.hyprland.settings.exec-once = [
    "sleep 2 && hyprpanel"  # Small delay to ensure other services start first
  ];
}