{ pkgs, ... }:

{
  home.packages = with pkgs; [
    hidden-bar
    raycast
    maccy
    alt-tab-macos
    stats
  ];
}
