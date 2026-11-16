{ pkgs, lib, ... }:

let
  # Commit email per folder. Anything outside these uses the default email below.
  identities = {
    "~/deels/" = "pavel.holman@deels.cz";
    "~/poqet/" = "pavel.holman@poqet.cz";
    "~/merica/" = "pavelholman@email.cz";
    "~/dev/fel/" = "holmapav@cvut.cz";
    "~/dev/fit/" = "holmapav@cvut.cz";
    "~/dev/mff/" = "holmapav@cvut.cz";
  };
in
{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Pavel Holman";
        email = "pavelholman@email.cz";
      };
      pull.rebase = true;
    };
    includes = lib.mapAttrsToList (dir: email: {
      condition = "gitdir:${dir}";
      contents.user.email = email;
    }) identities;
    signing = {
      key = "EBE8FC92F0E6458375B8918A604C44A1DD4A0B69";
      signByDefault = true;
    };
    lfs.enable = true;
    ignores = [ ".DS_Store" ];
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
  };

  programs.gpg.enable = true;
  programs.gitui.enable = true;
  programs.lazygit = {
    enable = true;
    settings.git.disableForcePushing = true;
  };

  home.packages = [ pkgs.git-secret ];
}
