{ config, pkgs, ... }: 
{
  home.packages = with pkgs; [
    # Programming environments.
    python3
    nodejs
    cargo
    rustc
    
    # Development tools
    curl
    wget
    unzip
    gzip
    fzf
    fd
    ripgrep

    # Language servers
    rust-analyzer
    pyright
    nodePackages.typescript-language-server
    nodePackages.vscode-langservers-extracted
    lua-language-server


    # Formatters/linters

    nodePackages.prettier
    black
    rustfmt

    # utilities

    gh
    jq
    yq
    bat
    lazygit

    # cloud tools
    awscli2

  ];

}
