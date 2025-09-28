{ config, pkgs, inputs, ... }:

{
  # Import Stylix home-manager module (using new module path)
  imports = [
    inputs.stylix.homeModules.stylix
  ];

  # Minimal Stylix configuration
  stylix = {
    enable = true;
    
    # Use a simple base16 theme
    base16Scheme = "${pkgs.base16-schemes}/share/themes/material-darker.yaml";
    
    # Disable auto-detection of targets
    autoEnable = false;
    
    # Minimal font configuration
    fonts = {
      monospace = {
        package = pkgs.jetbrains-mono;
        name = "JetBrains Mono";
      };
    };
    
    # ONLY enable GTK theming for now - nothing else
    targets = {
      waybar.enable = true;
      kitty.enable = true;
    };
  };
}
