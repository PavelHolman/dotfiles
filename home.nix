{ config, pkgs, ... }:

{
  imports = [
    ./git.nix
    ./terminal.nix
  ];

  catppuccin = {
    enable = true;
    flavor = "mocha";
    accent = "flamingo";

    pointerCursor.enable = true;
  };

  gtk = {
    enable = true;

    catppuccin = {
      enable = true;
      gnomeShellTheme = true;
      icon.enable = true;
    };
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

  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = (_: true);
  };

  home.packages = with pkgs; [
    zip
    unzip
    xdg-utils

    slack
  ];

  programs.home-manager.enable = true;
}
