{ pkgs, ... }:

{
  programs.vscode.enable = true;

  home.packages = with pkgs; [
    rustup
  ];
}
