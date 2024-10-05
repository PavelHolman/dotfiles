{ pkgs, ... }:

{
  fonts = {
    fontconfig = {
      enable = true;
      defaultFonts.monospace = [ "JetBrainsMono Nerd Font Mono" ];
    };
  };
  home.packages = with pkgs; [
    jetbrains-mono
    nerdfonts
  ];
}
