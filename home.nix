{ config, pkgs, ... }:

{
  imports = [
    ./git.nix
    ./terminal.nix
  ];

  catppuccin = {
    enable = true;
    flavor = "mocha";
    accent = "mauve";

    pointerCursor.enable = true;
  };

  home.username = "pajax";
  home.homeDirectory = "/home/pajax";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  home.packages = with pkgs; [
    zip
    unzip
    xdg-utils
  ];

  programs.home-manager.enable = true;
}
