{ pkgs, ... }:

let
  you-should-use = pkgs.fetchFromGitHub {
    owner = "MichaelAquilina";
    repo = "zsh-you-should-use";
    rev = "v1.8.0";
    sha256 = "139njh3z63vv22lq1df05w1rgknx95fj5njz31zgsm3hr7izp5bw";
  };
  shellAliases = {
    cat = "bat";
    grep = "rg";
    gll = "git log --graph --abbrev-commit --decorate --all --date=format:'%Y-%m-%d %H:%M:%S' --format=format:'%C(bold blue)%h%C(reset) on %C(bold cyan)%ad%C(reset) %C(bold green)(%ar)%C(reset) %C(dim white)by %an%C(reset) %C(auto)%d%C(reset) %n%C(white)%s%C(reset)%n'";
  };
in
{
  programs = {
    kitty = {
      enable = true;
      shellIntegration.enableZshIntegration = true;
      extraConfig = ''
        enable_audio_bell no
      '';
    };
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    zsh = {
      enable = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      oh-my-zsh = {
        enable = true;
        plugins = [
          "git"
          "rust"
          "aliases"
          "docker"
        ];
      };
      plugins = [
        {
          name = "you-should-use";
          src = you-should-use;
        }
      ];
      shellAliases = shellAliases;
    };
    nushell = {
      enable = true;
    };
    carapace = {
      enable = true;
    };
    starship = {
      enable = true;
      settings = pkgs.lib.importTOML ./starship.toml;
    };
    zellij = {
      enable = true;
    };
    helix = {
      enable = true;
      defaultEditor = true;
    };
    fzf = {
      enable = true;
    };
    zoxide = {
      enable = true;
      options = [ "--cmd cd" ];
    };
    eza = {
      enable = true;
      icons = true;
      git = true;
    };
    ripgrep = {
      enable = true;
    };
    bat = {
      enable = true;
    };
    yazi = {
      enable = true;
      enableZshIntegration = true;
    };
    btop = {
      enable = true;
      package = pkgs.btop.override { cudaSupport = true; };
      settings = {
        theme_background = false;
        shown_boxes = "proc cpu mem net gpu0";
      };
    };
  };
}
