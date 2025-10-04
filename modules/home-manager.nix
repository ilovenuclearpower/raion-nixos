{ config, pkgs, ... }:

let
	home-manager = builtins.fetchTarball https://github.com/nix-community/home-manager/archive/release-25.05.tar.gz;
in
{
  # Import Home Manager NixOS module
  imports = [
    <home-manager/nixos>
  ];

  # Enable Home Manager for your user
  home-manager = {
    # Use the global pkgs instance
    useGlobalPkgs = true;
    
    # Use the user's home directory from the system configuration
    useUserPackages = true;
    
    # Configure Home Manager for your user(s)
    users.hik = { pkgs, ... }: {
      # Home Manager needs a bit of information about you and the
      # paths it should manage
      home = {
        username = "hik";
        homeDirectory = "/home/hik";
        
        # This value determines the Home Manager release that your
        # configuration is compatible with
        stateVersion = "25.05";
        
        # Packages to install in user profile
        packages = with pkgs; [
          # Add your user-specific packages here
	  git
          htop
        ];
      };

      # Let Home Manager install and manage itself
      programs.home-manager.enable = true;

      # Configure Git (example)
      programs.git = {
        enable = true;
        userName = "hik";
        userEmail = "hik@aboveaverage.space";
      };

      # Configure Bash (example)
      programs.bash = {
        enable = true;
        bashrcExtra = ''
          # Custom bash configuration
          export EDITOR=nvim
        '';
      };

      # Configure other programs as needed
      programs.direnv = {
        enable = true;
        nix-direnv.enable = true;
      };
    };
    
    # Optional: Extra specialArgs to pass to Home Manager configurations
    extraSpecialArgs = {
      # You can pass additional arguments here if needed
      inherit pkgs;
    };
  };
}
