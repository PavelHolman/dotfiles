{
  description = "Very Epic MacOS Nix Darwin Config";

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-26.05-darwin";
    nixpkgs-unstable.url = "nixpkgs/nixpkgs-unstable";

    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    catppuccin.url = "github:catppuccin/nix";
    catppuccin.inputs.nixpkgs.follows = "nixpkgs";

    mac-app-util.url = "github:hraban/mac-app-util";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nixpkgs-unstable, home-manager, catppuccin, mac-app-util, ...  }:
  let
    system = "aarch64-darwin";
    pkgs = nixpkgs.legacyPackages.${system};
    pkgs-unstable = nixpkgs-unstable.legacyPackages.${system};
    configuration = { pkgs, ... }: {
      nixpkgs.config.allowUnfree = true;
    
      environment.systemPackages = with pkgs; [];

      security.pam.services.sudo_local.touchIdAuth = true;

      nix.settings.experimental-features = "nix-command flakes";
      nix.settings.trusted-users = [ "root" "pavelholman" ];

      system.primaryUser = "pavelholman";

      programs.zsh.enable = true;

      # Remap Caps Lock to Escape (pairs well with modal editors like Helix)
      system.keyboard.enableKeyMapping = true;
      system.keyboard.remapCapsLockToEscape = true;

      system.defaults = {
        finder = {
          AppleShowAllExtensions = true;
          FXPreferredViewStyle = "Nlsv";
          ShowPathbar = true;
          ShowStatusBar = true;
        };
        NSGlobalDomain = {
          KeyRepeat = 2;
          InitialKeyRepeat = 15;
        };
        screencapture.location = "~/Captures";
      };

      # Tiling window manager. Kept deliberately minimal: no scripting
      # addition, so no SIP changes needed - just grant Accessibility
      # access when macOS prompts on first launch. This gets you basic
      # BSP tiling, focus, swap and fullscreen-zoom. Things that DO need
      # the scripting addition (multi-space move/create, window shadows/
      # transparency/animations) are left out; add `enableScriptingAddition
      # = true` plus the SIP steps from the yabai wiki later if you want them.
      services.yabai = {
        enable = true;
        config = {
          layout = "bsp";
          window_gap = 10;
          top_padding = 10;
          bottom_padding = 10;
          left_padding = 10;
          right_padding = 10;
        };
        extraConfig = ''
          yabai -m rule --add app="^System Settings$" manage=off
          yabai -m rule --add app="^Finder$" manage=off
          yabai -m rule --add app="^AltTab$" manage=off
        '';
      };

      services.skhd = {
        enable = true;
        skhdConfig = ''
          # focus window
          alt - h : yabai -m window --focus west
          alt - j : yabai -m window --focus south
          alt - k : yabai -m window --focus north
          alt - l : yabai -m window --focus east

          # swap window
          shift + alt - h : yabai -m window --swap west
          shift + alt - j : yabai -m window --swap south
          shift + alt - k : yabai -m window --swap north
          shift + alt - l : yabai -m window --swap east

          # toggle window fullscreen zoom
          alt - f : yabai -m window --toggle zoom-fullscreen

          # restart yabai
          ctrl + alt - r : launchctl kickstart -k "gui/''${UID}/org.nixos.yabai"
        '';
      };

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 5;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = system;

      users.users.pavelholman = {
        name = "pavelholman";
        home = "/Users/pavelholman";
      };
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#simple
    darwinConfigurations."PJ-MacBook-Pro" = nix-darwin.lib.darwinSystem {
      inherit system;
      modules = [
        configuration
        mac-app-util.darwinModules.default
        home-manager.darwinModules.home-manager
        {
          # Set Git commit hash for darwin-version.
          system.configurationRevision = self.rev or self.dirtyRev or null;

          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "before-nix-home-manager";

          home-manager.sharedModules = [
            mac-app-util.homeManagerModules.default
          ];

          home-manager.users.pavelholman = {
            imports = [
              ./home.nix
              catppuccin.homeModules.catppuccin
            ];
          };

          home-manager.extraSpecialArgs = {
            inherit pkgs-unstable;
          };
        }
      ];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."PJ-MacBook-Pro".pkgs;
  };
}
