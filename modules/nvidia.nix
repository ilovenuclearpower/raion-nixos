# NixOS configuration for Nvidia RTX 3080 LHR
{ config, pkgs, ... }:

{
  # Enable OpenGL
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead 
    # of just the bare essentials.
    powerManagement.enable = false;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of 
    # supported GPUs is at: 
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
    # Only available from driver 515.43.04+
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = false;

    # Enable the Nvidia settings menu,
    # accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    # For RTX 3080, the latest stable driver should work fine.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # Optional: Enable CUDA support if you need it for development or specific applications
  # Uncomment the following lines if needed:
  # nixpkgs.config.allowUnfree = true;
  # environment.systemPackages = with pkgs; [
  #   cudatoolkit
  #   nvidia-settings
  # ];

  # Optional: If you're using a laptop with hybrid graphics (Intel + Nvidia)
  # Uncomment and configure the following:
  # hardware.nvidia.prime = {
  #   sync.enable = true;
  #   # Make sure to use the correct Bus ID values for your system
  #   # You can find them using: lspci | grep VGA
  #   intelBusId = "PCI:0:2:0";    # Replace with your Intel GPU Bus ID
  #   nvidiaBusId = "PCI:1:0:0";   # Replace with your Nvidia GPU Bus ID
  # };

  # Optional: If you want to use Wayland with Nvidia (experimental)
  # Uncomment the following:
  # environment.sessionVariables = {
  #   # Enable Wayland support
  #   GBM_BACKEND = "nvidia-drm";
  #   __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  #   WLR_NO_HARDWARE_CURSORS = "1";
  # };

  # Optional: Gaming optimizations
  # Uncomment if you're using this system for gaming:
  # programs.gamemode.enable = true;
  # programs.steam = {
  #   enable = true;
  #   remotePlay.openFirewall = true;
  #   dedicatedServer.openFirewall = true;
  # };
}
