
{ config, pkgs, inputs, ...}:
let
  unstable = inputs.nixpkgs-unstable.legacyPackages.${pkgs.system};
in
{
  # Install ncspot from unstable
  home.packages = with pkgs; [
   calibre 
  ];
}
