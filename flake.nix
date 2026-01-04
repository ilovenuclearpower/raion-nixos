{
  description = "NixOS configuration with Hyprland and Home Manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = { url = "github:danth/stylix/release-25.05"; inputs.nixpkgs.follows = "nixpkgs"; };
    nixvim = {
      url = "github:nix-community/nixvim/nixos-25.05";
    };
    rose-pine-hyprcursor = { url = "github:ndom91/rose-pine-hyprcursor/v0.3.2"; };
    hyprcursor-phinger.url = "github:jappie3/hyprcursor-phinger";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, ... }@inputs: {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; unstable = import nixpkgs-unstable { system = "x86_64-linux"; config.allowUnfree = true; };};
        modules = [
          # Your existing configuration files
          ./configuration.nix
          ./hardware-configuration.nix
          ./modules/thrustmaster/wheel.nix
          { nixpkgs.config.allowUnfree = true; }

          # Enable flakes system-wide
          ({ pkgs, ... }: {
            nix = {
              package = pkgs.nixVersions.stable;
              extraOptions = ''
                experimental-features = nix-command flakes
              '';
            };
            
            # Enable Hyprland (using nixpkgs version for now)
            programs.hyprland = {
              enable = true;
              xwayland.enable = true;
            };
          })
          
          # Home Manager as NixOS module
          home-manager.nixosModules.home-manager
          {
            home-manager.useUserPackages = true;
            # Your actual username
            home-manager.users.hik = import ./home.nix;
	    # Backup file extension to stop rebuild conflicts
	    home-manager.backupFileExtension = "backup";
            
            # Pass inputs to home-manager
            home-manager.extraSpecialArgs = { inherit inputs; wallpaper = ./wallpapers/rainbowumbrella.png; };
            
            # Add nixvim module to home-manager
            home-manager.sharedModules = [ inputs.nixvim.homeManagerModules.nixvim ];
          }
        ];
      };
    };
  };
}
