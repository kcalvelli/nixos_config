{
  config,
  pkgs,
  lib,
  ...
}:
{
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting

      # Colors for #080C12
      set -g fish_color_normal        e0e4e9
      set -g fish_color_command       86e8ef
      set -g fish_color_keyword       cba6f7
      set -g fish_color_param         b3d4ff
      set -g fish_color_quote         7fe0b4
      set -g fish_color_redirection   f5e38a
      set -g fish_color_end           9ca4ae
      set -g fish_color_error         ff9e9e
      set -g fish_color_comment       2a3a4e
      set -g fish_color_selection     --background=2a3a4e
      set -g fish_color_search_match  --background=2a3a4e
      set -g fish_color_operator      9ca4ae
      set -g fish_color_escape        f5e38a
      set -g fish_color_autosuggestion 2a3a4e
      set -g fish_pager_color_description 9ca4ae
      set -g fish_pager_color_completion  e0e4e9
      set -g fish_pager_color_prefix      b3d4ff --bold
      set -g fish_pager_color_progress    2a3a4e

      # direnv
      command -q direnv; and direnv hook fish | source

      # zoxide / fzf
      if type -q zoxide
        zoxide init fish | source
      end
      if type -q fzf
        function _fzf_file --description 'Fuzzy file insert'
          set -l file (fd . --hidden --follow --exclude .git | fzf)
          and commandline -it -- " $file"
        end
        bind \cf '_fzf_file'
      end

      # Copilot & Claude toggles (drive Starship badges)
      function copilot-on;  set -gx GITHUB_COPILOT_ENABLED 1;    echo "Copilot: ON";  end
      function copilot-off; set -e  GITHUB_COPILOT_ENABLED;      echo "Copilot: OFF"; end
      function claude-on;   set -gx CLAUDE_CODE_ENABLED 1;       echo "Claude: ON";   end
      function claude-off;  set -e  CLAUDE_CODE_ENABLED;         echo "Claude: OFF";  end

      # Copilot CLI helpers (requires: gh ext install github/copilot)
      function co-suggest --description 'Copilot: suggest for last cmd'
        gh copilot suggest -t shell (history | head -n1)
      end
      function co-explain --description 'Copilot: explain a command'
        if test (count $argv) -eq 0
          echo "Usage: co-explain <command>"; return 2
        end
        gh copilot explain -- $argv
      end
      abbr -a co  'gh copilot suggest -t shell'
      abbr -a cot 'gh copilot suggest -t terminal'
      abbr -a coe 'gh copilot explain'

      # Claude CLI shortcuts (if installed)
      abbr -a cl   'claude -s "You are a concise coding assistant."'
      abbr -a clex 'claude -t explain --'

      # Git QoL
      abbr -a gs  'git status -sb'
      abbr -a ga  'git add -A'
      abbr -a gc  'git commit -m'
      abbr -a gco 'git checkout'
      abbr -a gb  'git switch -c'
      abbr -a gl  'git log --oneline --graph --decorate -20'
      abbr -a mkcd 'mkdir -p && cd'
    '';
    plugins = [
      # { name = "fzf"; src = pkgs.fishPlugins.fzf.src; }
      # { name = "z";   src = pkgs.fishPlugins.z.src; }
      # { name = "github-copilot-cli-fish"; src = pkgs.fishPlugins.github-copilot-cli-fish.src; }
    ];
  };
}
