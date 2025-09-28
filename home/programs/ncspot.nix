{ config, pkgs, inputs, ...}:
let
  unstable = inputs.nixpkgs-unstable.legacyPackages.${pkgs.system};
in
{
  # Install ncspot from unstable
  home.packages = with pkgs; [
    unstable.ncspot
  ];

  # ncspot configuration
  home.file.".config/ncspot/config.toml".text = ''
    [theme]
    background = "#1e1e1e"
    primary = "#ffffff"
    secondary = "#888888"
    title = "#61dafb"
    playing = "#98c379"
    playing_selected = "#98c379"
    playing_bg = "#2d3748"
    highlight = "#ffffff"
    highlight_bg = "#4a5568"
    error = "#e06c75"
    error_bg = "#1e1e1e"
    statusbar = "#2d3748"
    statusbar_progress = "#61dafb"
    statusbar_bg = "#1a202c"
    cmdline = "#ffffff"
    cmdline_bg = "#2d3748"
    search_match = "#e5c07b"
  '';
}
