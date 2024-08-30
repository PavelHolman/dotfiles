{ pkgs, pkgs-unstable, ... }:

{
  home.packages = with pkgs; [
    gnome.gnome-tweaks
    gnome.gnome-keyring
    gnomeExtensions.caffeine
    gnomeExtensions.dash-to-dock
    gnomeExtensions.tray-icons-reloaded
    pkgs-unstable.gnomeExtensions.keyboard-reset
  ];

  gtk = {
    enable = true;

    catppuccin = {
      enable = true;
      gnomeShellTheme = true;
      icon.enable = true;
    };
  };

  dconf = {
    enable = true;
    settings = {
      "org/gnome/shell" = {
        disable-user-extensions = false;
        enabled-extensions = [
          pkgs.gnomeExtensions.caffeine.extensionUuid
          pkgs.gnomeExtensions.dash-to-dock.extensionUuid
          pkgs.gnomeExtensions.tray-icons-reloaded.extensionUuid
          pkgs-unstable.gnomeExtensions.keyboard-reset.extensionUuid
        ];
      };
    };
  };
}
