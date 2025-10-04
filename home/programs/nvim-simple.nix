{ config, pkgs, ... }:
{
  # Use nixvim for a declarative Neovim configuration
  programs.nixvim = {
    enable = true;
    colorschemes.nord.enable = true;
    
    # Basic options
};
}
