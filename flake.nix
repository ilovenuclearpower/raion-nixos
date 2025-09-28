{
  description = "NixOS configuration with Home Manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
    nixosConfigurations = {
      # Replace "yourhostname" with your actual hostname
      yourhostname = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux"; # Change if needed (aarch64-linux for ARM)
        modules = [
          # Your existing configuration files
          ./configuration.nix
          ./hardware-configuration.nix
          
          # Enable flakes system-wide
          ({ pkgs, ... }: {
            nix = {
              package = pkgs.nixFlakes;
              extraOptions = ''
                experimental-features = nix-command flakes
              '';
            };
          })
          
          # Home Manager as NixOS module
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            # Replace "yourusername" with your actual username
            home-manager.users.yourusername = import ./home.nix;
            
            # Optionally use the same nixpkgs as system
            home-manager.extraSpecialArgs = { inherit inputs; };
          }
        ];
      };
    };
  };
}
