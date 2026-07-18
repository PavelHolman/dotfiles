{ pkgs, ...}:

{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Pavel Holman";
        email = "pavelholman@email.cz";
      };
      includeIf."gitdir:~/Deels/".path = "~/.gitconfig-deels";
      includeIf."gitdir:~/Merica/".path = "~/.gitconfig-merica";
      includeIf."gitdir:~/FIT/".path = "~/.gitconfig-fit";
      includeIf."gitdir:~/MFF/".path = "~/.gitconfig-mff";
      pull.rebase = true;
    };
    signing = {
      key = "EBE8FC92F0E6458375B8918A604C44A1DD4A0B69";
      signByDefault = true;
    };
    lfs.enable = true;
    ignores = [
      ".DS_Store"
    ];
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
  };

  programs.gpg.enable = true;
  programs.gitui.enable = true;
  programs.lazygit = {
    enable = true;
    settings = {
      git = {
        disableForcePushing = true;
      };
    };
  };

  home.packages = with pkgs; [
    git-secret
  ];

  home.file.".gitconfig-deels".text = ''
    [user]
      email = "pavel.holman@deels.cz"

    [core]
      autocrlf = false
  '';

  home.file.".gitconfig-merica".text = ''
    [user]
      email = "pavelholman@email.cz"

    [core]
      autocrlf = false
  '';

  home.file.".gitconfig-mff".text = ''
    [user]
      email = "holmapav@cvut.cz"
  '';

  home.file.".gitconfig-fit".text = ''
    [user]
      email = "holmapav@fit.cvut.cz"
  '';
}
