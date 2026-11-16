{ pkgs, ... }:

{
  home.packages = with pkgs; [
    hidden-bar
    stats
    sketchybar
  ];
}
