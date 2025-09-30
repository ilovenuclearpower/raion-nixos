{ config, pkgs, inputs, ... }:
let 
unstable = inputs.nixpkgs-unstable.legacyPackages.${pkgs.system};
in
{
  imports = [
  ./home/programs/nvim.nix
  ./home/programs/ncspot.nix
  ./home/desktop/hyprland.nix
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

  # Your existing GTK config

  qt = {
    enable = true;
    platformTheme.name = "adwaita"; 
    style = {
      name = "adwaita-dark";
    };
  };

  home.stateVersion = "25.05"; # Match your NixOS version

  # Disable the version check warning for now
  home.enableNixpkgsReleaseCheck = false;

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;
  programs.kitty.enable = true;
  

  # User packages
  home.packages = with pkgs; [
    # Wayland clipboard utilities
    wl-clipboard
    
    # Additional utilities
    btop
    neofetch
    tree
    tofi
    home-manager


    # Programming environments.

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
  programs.neovim = {
    enable = true;
  };
}
