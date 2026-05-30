{ config, pkgs, ... }:

{
  imports = [
    ./home/dev.nix
    ./home/fonts.nix
    ./home/git.nix
    ./home/macos.nix
    ./home/terminal.nix
    ./home/theme.nix
  ];

  home.packages = with pkgs; [
  ];

  home.file = {
  };

  home.sessionVariables = {
  };

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "26.05"; # Please read the comment before changing.

  programs.home-manager.enable = true;
}

