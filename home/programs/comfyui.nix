{ config, pkgs, lib, ... }:

let
  cfg = config.services.comfyui;
  
  # Define the ComfyUI package inline
  comfyui-pkg = pkgs.python3Packages.buildPythonApplication rec {
    pname = "comfyui";
    version = "0.3.75";
    format = "other";

    src = pkgs.fetchFromGitHub {
      owner = "comfyanonymous";
      repo = "ComfyUI";
      rev = "v${version}";
      hash = "sha256-T6O6UzcIcBsLWGHmgRnQB/EgsM5Mw2OTmMRq+BBtwsE=";
    };

    nativeBuildInputs = [ pkgs.makeWrapper pkgs.uv pkgs.python3Packages.pip ];

    dontBuild = true;

    propagatedBuildInputs = with pkgs.python3Packages; [
      aiohttp numpy pillow psutil pyyaml safetensors scipy
      torch torchaudio torchvision tqdm transformers gitpython
      opencv4 piexif numba gguf pip ultralytics insightface
      diffusers huggingface-hub accelerate xformers
    ] ++ [ pkgs.uv ];

    installPhase = ''
      runHook preInstall
      mkdir -p $out/opt/comfyui
      cp -r ./* $out/opt/comfyui/

      runHook postInstall
    '';

    meta = with pkgs.lib; {
      description = "The most powerful and modular diffusion model GUI, api and backend with a graph/nodes interface";
      homepage = "https://github.com/comfyanonymous/ComfyUI";
      license = licenses.gpl3Only;
      platforms = platforms.all;
    };
  };
  
  comfyui-wrapper = pkgs.writeShellScript "comfyui-wrapper" ''
    set -e
    
    export COMFY_DIR=${config.home.homeDirectory}/.config/comfy-ui
    export VENV_DIR=$COMFY_DIR/venv
    export APP_DIR=$COMFY_DIR/app
    
    # ROCm/AMD GPU environment
    export HSA_OVERRIDE_GFX_VERSION=11.0.0
    
    # Comprehensive library path for PyTorch and dependencies
    export LD_LIBRARY_PATH=${lib.makeLibraryPath [
      pkgs.rocmPackages.clr
      pkgs.stdenv.cc.cc.lib
      pkgs.glib
      pkgs.libGL
      pkgs.libGLU
      pkgs.zstd
      pkgs.zlib
      pkgs.bzip2
      pkgs.xz
      pkgs.lz4
      pkgs.libpng
      pkgs.libjpeg
      pkgs.libtiff
      pkgs.libwebp
    ]}:/run/opengl-driver/lib:$LD_LIBRARY_PATH
    
    # Add build tools to PATH for packages that need compilation
    export PATH=${pkgs.cmake}/bin:${pkgs.gcc}/bin:${pkgs.ninja}/bin:$PATH

    # Create directory structure (including custom_nodes)
    mkdir -p $COMFY_DIR/{models,output,input,temp,custom_nodes}
    
    # Copy ComfyUI source if not present
    if [ ! -d $APP_DIR ]; then
      echo 'Copying ComfyUI source...'
      cp -r ${comfyui-pkg}/opt/comfyui $APP_DIR
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
      echo 'Installing PyTorch with ROCm support (this will take several minutes)...'
      # Install PyTorch from ROCm index
      $VENV_DIR/bin/pip install \
        torch torchvision torchaudio --index-url https://download.pytorch.org/whl/rocm6.2
      
      echo 'Installing ComfyUI requirements...'
      # Install ComfyUI requirements from PyPI
      $VENV_DIR/bin/pip install -r $APP_DIR/requirements.txt
      
      echo 'Installing additional dependencies...'
      # Install additional packages from PyPI (removed version constraint on huggingface-hub)
      $VENV_DIR/bin/pip install \
        segment-anything dill facexlib piexif insightface deepdiff webcolors \
        ultralytics huggingface-hub py-cpuinfo gguf \
        onnxruntime imageio-ffmpeg opencv-python numba pynvml timm
      
      # Try to install llama-cpp-python (optional, may take a while to compile)
      echo 'Installing llama-cpp-python (optional, this may take 5-10 minutes to compile)...'
      $VENV_DIR/bin/pip install llama-cpp-python || echo 'Warning: llama-cpp-python installation failed, skipping...'
      
      touch $COMFY_DIR/.deps_complete
      echo 'All dependencies installed successfully!'
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
    home.packages = [ comfyui-pkg ];

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
        
        # Allow up to 30 minutes for first-time dependency installation
        TimeoutStartSec = "30min";
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };
  };
}
