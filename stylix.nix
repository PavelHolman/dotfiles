{ pkgs, stylix, ... }:

{
  stylix = {
    enable = true;
    autoEnable = true;

    # https://tinted-theming.github.io/base16-gallery/
    base16Scheme = let theme = "catppuccin-mocha";
    in "${pkgs.base16-schemes}/share/themes/${theme}.yaml";

    polarity = "dark";

    image = /home/pajax/.dotfiles/waves.png;

    cursor = {
      package = pkgs.catppuccin-cursors;
      name = "mochaMauve";
    };

    fonts = {
      monospace = {
        name = "JetBrainsMono Nerd Font";
        package = pkgs.jetbrains-mono;
      };
    };

    opacity.terminal = 0.95;
  };
}
