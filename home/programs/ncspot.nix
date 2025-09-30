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
  background = "${config.lib.stylix.colors.base00}"
  primary = "${config.lib.stylix.colors.base05}"
  secondary = "${config.lib.stylix.colors.base04}"
  title = "${config.lib.stylix.colors.base0D}"
  playing = "${config.lib.stylix.colors.base0B}"
  playing_selected = "${config.lib.stylix.colors.base0B}"
  playing_bg = "${config.lib.stylix.colors.base01}"
  highlight = "${config.lib.stylix.colors.base0A}"
  highlight_bg = "${config.lib.stylix.colors.base02}"
  error = "${config.lib.stylix.colors.base08}"
  error_bg = "${config.lib.stylix.colors.base01}"
  statusbar = "${config.lib.stylix.colors.base04}"
  statusbar_progress = "${config.lib.stylix.colors.base0C}"
  statusbar_bg = "${config.lib.stylix.colors.base01}"
  cmdline = "${config.lib.stylix.colors.base05}"
  cmdline_bg = "${config.lib.stylix.colors.base01}"
  search_match = "${config.lib.stylix.colors.base00}"
'';
}
