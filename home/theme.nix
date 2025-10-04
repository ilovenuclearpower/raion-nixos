{ config, pkgs, inputs, wallpaper, ... }:

{
  # Import Stylix home-manager module (using new module path)
  imports = [
    inputs.stylix.homeModules.stylix
  ];

  home.packages = with pkgs; [
    papirus-icon-theme
    adwaita-icon-theme
  ];

  gtk = {
    enable = true;
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
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
        package = pkgs.nerd-fonts.iosevka;
        name = "Iosevka Nerd Font Mono";
      };
      sansSerif = {
        package = pkgs.nerd-fonts.iosevka;
        name = "Iosevka Nerd Font";
      };
      serif = {
        package = pkgs.nerd-fonts.iosevka;
        name = "Iosevka Nerd Font";
      };
      sizes = {
        applications = 16;
        desktop = 14;
        popups = 14;
        terminal = 14;
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
      gtk.flatpakSupport.enable = false;
      firefox.enable = true;
      btop.enable = true;
      qt.enable = true;
      qutebrowser.enable = true;
      hyprland.enable = true;
      hyprpaper.enable = true;
      waybar.enable = true;
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
