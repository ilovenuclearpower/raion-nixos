#.drivero Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running 'nixos-help').
{ config, pkgs, lib, unstable, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  networking.hostId = "fe1daed0";
  hardware.xone.enable = true;

  
  # Optional but recommended: enable ZFS services
  services.zfs.autoScrub.enable = true;

  # NixPkgs Config - Allow Unfree, Support Rocm 
  nixpkgs.config = {
    allowUnfree = true;
    rocmsupport = true;
  };
  # Use latest kernal with ZFS support
  boot.kernelPackages = pkgs.linuxPackagesFor pkgs.linuxKernel.kernels.linux_6_12;
  boot.kernelParams = [ "amdgpu.dc=1"];
  
  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  
  # Enable networking
  networking.networkmanager.enable = true;

  programs.steam = {
  	enable = true;
	remotePlay.openFirewall = true;
	dedicatedServer.openFirewall = true;
  };

  services.xserver = { 
    enable = true;
    videoDrivers = ["amdgpu"];
    };

  services.displayManager.sddm = {
    enable = false;
    wayland.enable = true;
    package = pkgs.kdePackages.sddm;
    theme = "sddm-astronaut-theme";
    extraPackages = with pkgs; [kdePackages.qtmultimedia kdePackages.qtvirtualkeyboard kdePackages.qtsvg];
  };
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd hyprland";
        user = "greeter";
};
};
};

  services.flatpak.enable = true;

  xdg.portal = {
  enable = true;
  extraPortals = [ pkgs.xdg-desktop-portal-gtk  pkgs.xdg-desktop-portal-hyprland pkgs.xdg-desktop-portal-gtk];
  };

  boot.initrd.kernelModules = ["amdgpu"]; 
  hardware.graphics = {
    enable = true; 
    enable32Bit = true;
    extraPackages = with pkgs; [
      mesa
      amdvlk
      rocmPackages.clr.icd
    ];
    extraPackages32 = with pkgs; [
      driversi686Linux.mesa
    ];
  };
  hardware.amdgpu.overdrive.enable = true;
  programs.gamemode.enable = true;

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
    options = "caps:escape";
  };
  
  
  # System packages
  environment.systemPackages = with pkgs; [

    # Web browser
    firefox
    # Text editor
    # Terminal emulator (useful for Hyprland)
    # File manager
    nautilus
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
    hyprpaper
    (sddm-astronaut.override  {
        embeddedTheme = "pixel_sakura_static";
      })

    # Clipboard
    wl-clipboard
    cliphist
    wtype

    # Filesystem utils
    gparted

    # Games Development w/ Unity
    unityhub

    # Unity Neovim wrapper script
    (pkgs.writeScriptBin "unity-nvim" ''
      #!/usr/bin/env bash
      
      # Unity Neovim Wrapper Script
      # This script launches Neovim with the user's nixvim configuration
      # for use with Unity's external script editor
      
      # Set environment variables for proper terminal operation
      export TERM=''${TERM:-xterm-256color}
      export COLORTERM=''${COLORTERM:-truecolor}
      
      # Ensure we're using the user's shell environment
      if [[ -f "$HOME/.bashrc" ]]; then
          source "$HOME/.bashrc"
      fi
      
      if [[ -f "$HOME/.profile" ]]; then
          source "$HOME/.profile"
      fi
      
      # Launch a terminal with Neovim
      # Unity expects the editor to open in a new window
      if command -v kitty >/dev/null 2>&1; then
          exec kitty --title "Unity Neovim" nvim "$@"
      elif command -v alacritty >/dev/null 2>&1; then
          exec alacritty --title "Unity Neovim" -e nvim "$@"
      elif command -v wezterm >/dev/null 2>&1; then
          exec wezterm start --always-new-process -- nvim "$@"
      elif command -v gnome-terminal >/dev/null 2>&1; then
          exec gnome-terminal --title="Unity Neovim" -- nvim "$@"
      else
          # Fallback to nvim directly if no terminal emulator is found
          exec nvim "$@"
      fi
    '')
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

  # Gotta have nerdfonts
  fonts.fontDir.enable = true;
  fonts.fontconfig.enable = true;
  
  # Define a user account. Don't forget to set a password with 'passwd'.
  users.users.hik = {
    isNormalUser = true;
    description = "hik";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };

  environment.etc."containers/registries.conf".text  = ''
    [registries.search]
    registries = ['docker.io', 'registry.gitlab.com']
  '';


  ## Enable GameDrive Filesystem
  fileSystems."/home/hik/data" = {
    device = "/dev/disk/by-label/data";
    fsType = "ext4";
    options  = [ "defaults" ];
  };

  ## Enable NFS Share
  fileSystems."/home/hik/rocinante" = {
    device = "192.168.4.89:/mnt/cant/fileshare";
    fsType = "nfs";
    options = [ "x-systemd.automount" "noauto" ];
  };
  fileSystems."/home/hik/calibre" = {
    device = "192.168.4.89:/mnt/cant/apps/calibre";
    fsType = "nfs";
    options = [ "x-systemd.automount" "noauto" ];
  };
  boot.supportedFilesystems = [ "nfs"  "zfs" ];

  
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you know that 'nixos-version --hash' shows the commit hash of this config?
}
