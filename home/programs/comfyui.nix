{ config, pkgs, lib, ... }:

let
  cfg = config.services.comfyui;
  
  comfyui-wrapper = pkgs.writeShellScript "comfyui-wrapper" ''
    set -e
    
    export NIXPKGS_ALLOW_UNFREE=1
    export COMFY_DIR=${config.home.homeDirectory}/.config/comfy-ui
    export VENV_DIR=$COMFY_DIR/venv
    export APP_DIR=$COMFY_DIR/app
    
    # ROCm/AMD GPU environment
    export HSA_OVERRIDE_GFX_VERSION=11.0.0
    export LD_LIBRARY_PATH=${pkgs.rocmPackages.clr}/lib:${pkgs.stdenv.cc.cc.lib}/lib:${pkgs.glib.out}/lib:${pkgs.libGL}/lib:/run/opengl-driver/lib:$LD_LIBRARY_PATH

    # Create directory structure
    mkdir -p $COMFY_DIR/{models,output,input,temp}
    
    # Copy ComfyUI source if not present
    if [ ! -d $APP_DIR ]; then
      echo 'Copying ComfyUI source...'
      cp -r ${pkgs.comfyui}/opt/comfyui $APP_DIR
      chmod -R u+w $APP_DIR
    fi

    # Create venv if it doesn't exist
    if [ ! -d $VENV_DIR ]; then
      echo 'Creating ComfyUI virtual environment...'
      ${pkgs.python3}/bin/python3 -m venv $VENV_DIR
      $VENV_DIR/bin/pip install --upgrade pip
    fi

    # Install dependencies
    if [ ! -f $COMFY_DIR/.deps_complete ]; then
      echo 'Installing ComfyUI dependencies...'
      $VENV_DIR/bin/pip install \
        torch torchvision torchaudio --index-url https://download.pytorch.org/whl/rocm6.2 \
        -r $APP_DIR/requirements.txt \
        segment-anything dill facexlib piexif insightface deepdiff webcolors \
        ultralytics 'huggingface-hub<0.25' py-cpuinfo gguf llama-cpp-python \
        onnxruntime imageio-ffmpeg opencv-python numba pynvml timm
      touch $COMFY_DIR/.deps_complete
    fi

    cd $APP_DIR
    exec $VENV_DIR/bin/python main.py --base-dir $COMFY_DIR --listen 0.0.0.0 "$@"
  '';
in
{
  options.services.comfyui = {
    enable = lib.mkEnableOption "ComfyUI server";
    
    port = lib.mkOption {
      type = lib.types.int;
      default = 8188;
      description = "Port to run ComfyUI on";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.comfyui ];

    systemd.user.services.comfyui = {
      Unit = {
        Description = "ComfyUI Server";
        After = [ "network.target" ];
      };
      Service = {
        Type = "exec";
        ExecStart = "${comfyui-wrapper} --port ${toString cfg.port}";
        Restart = "on-failure";
        RestartSec = 5;
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };
  };
}
