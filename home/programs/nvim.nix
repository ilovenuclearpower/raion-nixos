{ config, pkgs, ... }:
{
  home.file.".config/nvim" = {
    source = builtins.fetchGit {
    url = "https://github.com/ilovenuclearpower/nvim";
    rev = "aed7e94b894dd49200c451db217794bc2401124d";
    };
    recursive = true;
  };
}
