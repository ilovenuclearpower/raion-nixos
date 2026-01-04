{ config, pkgs, ... }:

let
  hid-tmff2 = config.boot.kernelPackages.callPackage ./hid-tmff2.nix {};
in
{
  boot.blacklistedKernelModules = [ "hid-thrustmaster" ];
  boot.extraModulePackages = [ hid-tmff2 ];
  boot.kernelModules = [ "hid-tmff2" ];
}
