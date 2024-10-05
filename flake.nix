{
  description = "Very Epic MacOS Nix Darwin Config";

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-24.05-darwin";
    nixpkgs-unstable.url = "nixpkgs/nixpkgs-unstable";

    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    catppuccin.url = "github:catppuccin/nix";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nixpkgs-unstable, home-manager, catppuccin, ...  }:
  let
    system = "aarch64-darwin";
    pkgs = nixpkgs.legacyPackages.${system};
    pkgs-unstable = nixpkgs-unstable.legacyPackages.${system};
    configuration = { pkgs, ... }: {
      nixpkgs.config.allowUnfree = true;
    
      environment.systemPackages = with pkgs; [];

      security.pam.enableSudoTouchIdAuth = true;

      services.nix-daemon.enable = true;

      nix.settings.experimental-features = "nix-command flakes";

      programs.zsh.enable = true;

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
    darwinConfigurations."PJBook" = nix-darwin.lib.darwinSystem {
      inherit system;
      modules = [
        configuration
        home-manager.darwinModules.home-manager
        {
          # Set Git commit hash for darwin-version.
          system.configurationRevision = self.rev or self.dirtyRev or null;

          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "before-nix-home-manager";

          home-manager.users.pavelholman = {
            imports = [
              ./home.nix
              catppuccin.homeManagerModules.catppuccin
            ];
          };

          home-manager.extraSpecialArgs = {
            inherit pkgs-unstable;
          };
        }
      ];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."PJBook".pkgs;
  };
}
