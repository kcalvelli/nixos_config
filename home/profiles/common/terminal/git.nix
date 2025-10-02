{
  config,
  pkgs,
  lib,
  ...
}:
{
  programs = {
    git = {
      enable = true;
      delta = {
        enable = lib.mkForce true;
        options = lib.mkForce {
            navigate = true;
            line-numbers = true;
            side-by-side = true;
            syntax-theme = "Monokai Extended";
            zero-style = "syntax";
            plus-style = "syntax #0c1a12";
            minus-style = "syntax #1a0c0f";
            plus-emph-style = "bold #7fe0b4";
            minus-emph-style = "bold #ff9e9e";
            commit-decoration-style = "bold yellow";
            file-decoration-style = "underline #b3d4ff";
            hunk-header-decoration-style = "blue box";
        };
      };  
      extraConfig = {
        core.pager = lib.mkForce "${pkgs.delta}/bin/delta";
        init.defaultBranch = "main";
        pull.ff = "only";
        push.default = "current";
        rebase.autoStash = true;
        rerere.enabled = true;
        branch.sort = "-committerdate";
        status.showUntrackedFiles = "all";
        color.ui = true;
        diff.colorMoved = "default";
        merge.conflictStyle = "zdiff3";
        fetch.prune = true;
        help.autocorrect = 20;
        alias = {
            co = "checkout";
            cob = "!f(){ git checkout -b \"$1\"; }; f";
            sw = "switch";
            ci = "commit";
            cia = "commit -a";
            amend = "commit --amend --no-edit";
            st = "status -sb";
            last = "log -1 --stat";
            lg = "log --graph --decorate --oneline --abbrev-commit";
            lga = "log --graph --decorate --oneline --all --abbrev-commit";
            unstage = "reset HEAD --";
            fixup = "commit --fixup";
            wip = "commit -am 'wip'";
        };
      };
    };
  };
}
