# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running 'nixos-help').
{ config, pkgs, unstable, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./modules/nvidia.nix
    ];
  
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  

  # Allow proprietary software
  nixpkgs.config.allowUnfree = true;
  
  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;
  
  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  
  # Enable networking
  networking.networkmanager.enable = true;

  services.xserver = { 
    enable = true;
    videoDrivers = ["nvidia"];
    };

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    package = pkgs.kdePackages.sddm;
    theme = "sddm-astronaut-theme";
    extraPackages = with pkgs; [kdePackages.qtmultimedia kdePackages.qtvirtualkeyboard kdePackages.qtsvg];
  };

  services.flatpak.enable = true;

  xdg.portal = {
  enable = true;
  extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  hardware.nvidia.modesetting.enable = true;
  environment.sessionVariables.WLR_NO_HARDWARE_CURSORS = "1";

 
  # Set your time zone.
  time.timeZone = "America/Los_Angeles";
  
  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };
  
  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };
  
  
  # System packages
  environment.systemPackages = with pkgs; [

    # App picker/launcher
    rofi-wayland
    # Status bar
    waybar
    # Web browser
    firefox
    # Text editor
    neovim
    # Terminal emulator (useful for Hyprland)
    # File manager
    nautilus
    # Notification daemon
    dunst
    # Screenshot utility
    grim
    slurp
    # Wallpaper setter
    swww
    # Audio control
    pavucontrol
    # Network manager applet
    networkmanagerapplet
    # Devtools installer
    mise
    git
    # menubar
    tofi
    hyprpaper
    (sddm-astronaut.override  {
        embeddedTheme = "hyprland_kath";
      })
  ];
  
  # Enable sound
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  
  # Enable Polkit for authentication
  security.polkit.enable = true;
  
  # Define a user account. Don't forget to set a password with 'passwd'.
  users.users.hik = {
    isNormalUser = true;
    description = "hik";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };
  
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you know that 'nixos-version --hash' shows the commit hash of this config?
}
