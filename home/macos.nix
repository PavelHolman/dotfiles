{ pkgs, ... }:

{
  home.packages = with pkgs; [
    hidden-bar
    raycast
  ];
}
