{ config, pkgs, ... }:

let
  claudeDevShell = pkgs.mkShell {
    name = "claude-dev-environment";
    buildInputs = with pkgs; [
      # Add your development tools here
      nodejs
      python3
      nodePackages.typescript
      nodePackages."@anthropic-ai/claude-code"
      # claude-code (when available)
    ];
    shellHook = ''
      echo "Claude development environment loaded"
    '';
  };
in
{
  # Make it available as a system package
  environment.systemPackages = [ claudeDevShell ];
}
