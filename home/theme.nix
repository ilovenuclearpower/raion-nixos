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
  # Minimal Stylix configuration
  stylix = {

    enable = true;
    
    # Disable auto-detection of targets
    autoEnable = true;
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
      hyprland.hyprpaper.enable = true;
      kitty.enable = true;
      gtk.enable = true;
      firefox.enable = true;
      btop.enable = true;
      qt.enable = true;
      qutebrowser.enable = true;
      hyprland.enable = true;
      hyprpaper.enable = true;
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
