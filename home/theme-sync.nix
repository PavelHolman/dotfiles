{ config, pkgs, ... }:

# Makes the Catppuccin-themed CLI tools follow macOS's Light/Dark appearance,
# the same way Ghostty already does. The Catppuccin nix module only bakes in
# a single static flavor (we keep it on "mocha" as the default/dark look via
# home/theme.nix), so everything below adds the missing "latte" (light)
# variant of each tool's theme/config alongside it, plus a small zsh layer
# that picks the right one at the moment each tool is launched.
#
# Tiers:
#  1. bat: has native terminal-background auto-detection, no scripting needed.
#  2. delta / starship / eza: switched via env vars, checked on each new
#     prompt (starship) or each invocation (delta, eza).
#  3. btop / gitui / zellij / helix / yazi / lazygit: these read their theme
#     once at startup, so switching only takes effect on the next launch -
#     a shell function picks the right theme file/flag when you run them.
#
# Caveat: the zsh functions below only apply to commands typed directly in
# an interactive zsh session. Anything launched by a GUI app (e.g. VS Code's
# git integration) will keep using the default (mocha/dark) theme.

let
  inherit (config.catppuccin) sources accent;

  # Mirrors the path logic used by catppuccin/nix's own lazygit module, so
  # our light-mode config chain lines up with the one it sets for dark mode.
  lazygitConfigDir =
    if (!pkgs.stdenv.hostPlatform.isDarwin || config.xdg.enable) then
      config.xdg.configHome
    else
      "${config.home.homeDirectory}/Library/Application Support";
  lazygitConfigFile = "${lazygitConfigDir}/lazygit/config.yml";

  mkStarshipSettings =
    flavor:
    (pkgs.lib.importTOML ./configs/starship.toml)
    // {
      format = "$all";
      palette = "catppuccin_${flavor}";
    }
    // (pkgs.lib.importTOML "${sources.starship}/${flavor}.toml");
in
{
  # --- Ghostty: the catppuccin module sets light:mocha,dark:mocha (both the
  # same flavor), which silently overwrites any light/dark pair on every
  # rebuild. Use Ghostty's own built-in Catppuccin themes instead. ---
  catppuccin.ghostty.enable = false;
  programs.ghostty.settings.theme = "light:Catppuccin Latte,dark:Catppuccin Mocha";

  # --- Tier 1: bat (built-in terminal-background auto-detection) ---
  catppuccin.bat.enable = false;
  programs.bat = {
    themes = {
      "Catppuccin Latte" = {
        src = sources.bat;
        file = "Catppuccin Latte.tmTheme";
      };
      "Catppuccin Mocha" = {
        src = sources.bat;
        file = "Catppuccin Mocha.tmTheme";
      };
    };
    config = {
      theme = "auto";
      theme-light = "Catppuccin Latte";
      theme-dark = "Catppuccin Mocha";
    };
  };

  # --- Tier 2/3: light-mode companion files (dark/mocha stays managed as before) ---
  home.file.".config/starship-latte.toml".source = (pkgs.formats.toml { }).generate
    "starship-latte.toml"
    (mkStarshipSettings "latte");

  home.file.".config/eza-latte/theme.yml".source =
    "${sources.eza}/latte/catppuccin-latte-${accent}.yml";

  home.file.".config/btop/theme-latte.conf".text = ''
    color_theme = "catppuccin_latte.theme"
    theme_background = False
    shown_boxes = "proc cpu mem net gpu0"
  '';

  home.file.".config/helix/config-latte.toml".text = ''
    theme = "catppuccin-latte"

    [editor]
    color-modes = true
  '';

  home.file.".config/yazi-latte/theme.toml".source =
    "${sources.yazi}/latte/catppuccin-latte-${accent}.toml";

  home.file.".config/lazygit-latte.yml".source =
    "${sources.lazygit}/latte/${accent}.yml";

  xdg.configFile = {
    "btop/themes/catppuccin_latte.theme".source = "${sources.btop}/catppuccin_latte.theme";
    "gitui/catppuccin-latte.ron".source = "${sources.gitui}/catppuccin-latte.ron";
    "helix/themes/catppuccin-latte.toml".source =
      "${sources.helix}/no_italics/catppuccin_latte.toml";
  };

  # --- The switcher: zsh functions that check the current macOS appearance ---
  programs.zsh.initContent = pkgs.lib.mkOrder 500 ''
    _catppuccin_mode() {
      if [[ "$(defaults read -g AppleInterfaceStyle 2>/dev/null)" == "Dark" ]]; then
        echo dark
      else
        echo light
      fi
    }

    _catppuccin_starship_sync() {
      if [[ "$(_catppuccin_mode)" == "light" ]]; then
        export STARSHIP_CONFIG="$HOME/.config/starship-latte.toml"
      else
        unset STARSHIP_CONFIG
      fi
    }
    autoload -Uz add-zsh-hook
    add-zsh-hook precmd _catppuccin_starship_sync

    git() {
      if [[ "$(_catppuccin_mode)" == "light" ]]; then
        DELTA_FEATURES="catppuccin-latte" command git "$@"
      else
        command git "$@"
      fi
    }

    eza() {
      if [[ "$(_catppuccin_mode)" == "light" ]]; then
        EZA_CONFIG_DIR="$HOME/.config/eza-latte" command eza "$@"
      else
        command eza "$@"
      fi
    }

    btop() {
      if [[ "$(_catppuccin_mode)" == "light" ]]; then
        command btop -c "$HOME/.config/btop/theme-latte.conf" "$@"
      else
        command btop "$@"
      fi
    }

    gitui() {
      if [[ "$(_catppuccin_mode)" == "light" ]]; then
        command gitui -t catppuccin-latte.ron "$@"
      else
        command gitui "$@"
      fi
    }

    zellij() {
      if [[ "$(_catppuccin_mode)" == "light" ]]; then
        command zellij options --theme catppuccin-latte "$@"
      else
        command zellij "$@"
      fi
    }

    hx() {
      if [[ "$(_catppuccin_mode)" == "light" ]]; then
        command hx -c "$HOME/.config/helix/config-latte.toml" "$@"
      else
        command hx "$@"
      fi
    }

    yazi() {
      if [[ "$(_catppuccin_mode)" == "light" ]]; then
        YAZI_CONFIG_HOME="$HOME/.config/yazi-latte" command yazi "$@"
      else
        command yazi "$@"
      fi
    }

    lazygit() {
      if [[ "$(_catppuccin_mode)" == "light" ]]; then
        LG_CONFIG_FILE="$HOME/.config/lazygit-latte.yml,${lazygitConfigFile}" \
          DELTA_FEATURES="catppuccin-latte" \
          command lazygit "$@"
      else
        command lazygit "$@"
      fi
    }
  '';
}
