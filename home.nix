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

  # Steam desktop mode launcher
  xdg.desktopEntries.steam = {
    name = "Steam";
    genericName = "Game Launcher";
    comment = "Launch Steam in desktop mode";
    exec = "steam-desktop";
    terminal = false;
    icon = "steam";
    type = "Application";
    categories = [ "Game" "Network" ];
  };

  # Steam Big Picture mode launcher
  xdg.desktopEntries.steam-bigpicture = {
    name = "Steam Big Picture";
    genericName = "Game Launcher";
    comment = "Launch Steam in Big Picture mode on workspace 7";
    exec = "steam-bigpicture";
    terminal = false;
    icon = "steam";
    type = "Application";
    categories = [ "Game" "Network" ];
    startupNotify = true;
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

    # Steam launcher scripts
    (pkgs.writeShellScriptBin "steam-desktop" ''
      #!/usr/bin/env bash
      LOGFILE="/tmp/steam-desktop.log"
      exec > "$LOGFILE" 2>&1

      echo "=== Steam Desktop Launch $(date) ==="
      echo "Starting script..."

      # Change to home directory to avoid bwrap issues
      cd "$HOME" || { echo "Failed to cd to HOME"; exit 1; }
      echo "Changed to: $(pwd)"

      # Kill Steam processes if running
      if pgrep -x steam > /dev/null; then
        echo "Steam is running, killing processes..."

        # Get PIDs and kill directly (faster than pkill)
        STEAM_PIDS=$(pgrep -x steam)
        HELPER_PIDS=$(pgrep -x steamwebhelper)

        echo "Found Steam PIDs: $STEAM_PIDS"
        echo "Found Helper PIDs: $HELPER_PIDS"

        # Kill each PID directly
        for pid in $STEAM_PIDS; do
          kill -9 "$pid" 2>/dev/null || true
        done

        for pid in $HELPER_PIDS; do
          kill -9 "$pid" 2>/dev/null || true
        done

        # Wait for processes to actually terminate
        echo "Waiting for processes to terminate..."
        for i in {1..10}; do
          if ! pgrep -x steam > /dev/null; then
            echo "Steam processes terminated after $i seconds"
            break
          fi
          sleep 1
        done

        # Extra wait for cleanup
        sleep 2
      else
        echo "Steam not running, proceeding to launch..."
      fi

      # Launch Steam
      echo "Launching Steam..."
      ${pkgs.steam}/bin/steam &
      STEAM_PID=$!
      echo "Steam launched with PID: $STEAM_PID"

      sleep 1
      echo "Script complete"
    '')

    (pkgs.writeShellScriptBin "steam-bigpicture" ''
      #!/usr/bin/env bash
      LOGFILE="/tmp/steam-bigpicture.log"
      exec > "$LOGFILE" 2>&1

      echo "=== Steam Big Picture Launch $(date) ==="
      echo "Starting script..."

      # Change to home directory to avoid bwrap issues
      cd "$HOME" || { echo "Failed to cd to HOME"; exit 1; }
      echo "Changed to: $(pwd)"

      # Kill Steam processes if running
      if pgrep -x steam > /dev/null; then
        echo "Steam is running, killing processes..."

        # Get PIDs and kill directly (faster than pkill)
        STEAM_PIDS=$(pgrep -x steam)
        HELPER_PIDS=$(pgrep -x steamwebhelper)

        echo "Found Steam PIDs: $STEAM_PIDS"
        echo "Found Helper PIDs: $HELPER_PIDS"

        # Kill each PID directly
        for pid in $STEAM_PIDS; do
          kill -9 "$pid" 2>/dev/null || true
        done

        for pid in $HELPER_PIDS; do
          kill -9 "$pid" 2>/dev/null || true
        done

        # Wait for processes to actually terminate
        echo "Waiting for processes to terminate..."
        for i in {1..10}; do
          if ! pgrep -x steam > /dev/null; then
            echo "Steam processes terminated after $i seconds"
            break
          fi
          sleep 1
        done

        # Extra wait for cleanup
        sleep 2
      else
        echo "Steam not running, proceeding to launch..."
      fi

      # Launch Steam in Big Picture mode
      echo "Launching Steam in Big Picture mode..."
      ${pkgs.steam}/bin/steam -bigpicture &
      STEAM_PID=$!
      echo "Steam launched with PID: $STEAM_PID"

      sleep 1
      echo "Script complete"
    '')

  ];

# Enable comfyui service
  services.comfyui = { 
    enable = true;
    port = 8188;
  };

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
