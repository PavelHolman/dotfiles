{ pkgs, ... }:

{
  home.packages = with pkgs; [
    alt-tab-macos
    hidden-bar
    stats
  ];
}
