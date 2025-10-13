{ config
, pkgs
, lib
, ...
}:
{
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      add_newline = true;

      palettes.axion = {
        base = "#e0e4e9";
        dim = "#9ca4ae";
        mute = "#2a3a4e";
        dir = "#b3d4ff";
        cyan = "#86e8ef";
        green = "#7fe0b4";
        yellow = "#f5e38a";
        red = "#ff9e9e";
        magenta = "#cba6f7";
      };
      palette = "axion";

      format = ''
        [╭─](bold $palette.mute)$username[@](bold $palette.base)$hostname[:](bold $palette.mute)$directory$git_branch$git_status$nix_shell$rust$zig$nodejs$python$copilot$claude
        [╰─➤ ](bold $palette.mute)$character
      '';

      character = {
        success_symbol = "[➜](bold $palette.base) ";
        error_symbol = "[➜](bold $palette.dim) ";
      };

      username = {
        format = "[$user]($style)";
        style_user = "bold $palette.base";
        style_root = "bold $palette.red";
        show_always = true;
      };
      hostname = {
        ssh_only = false;
        format = "[$hostname]($style)";
        style = "bold $palette.base";
      };
      directory = {
        style = "bold $palette.dir";
        truncation_length = 3;
        truncate_to_repo = true;
        read_only = " ";
        read_only_style = "bold $palette.yellow";
        format = "[ $path$read_only ]($style)";
      };

      git_branch = {
        symbol = " ";
        style = "bold $palette.base";
        format = "[ $symbol$branch ]($style)";
      };

      git_status = {
        format = "([ $all_status$ahead_behind ]($style))";
        style = "bold $palette.dim";

        conflicted = "✖" + "$" + "{count}";
        ahead = "⇡" + "$" + "{count}";
        behind = "⇣" + "$" + "{count}";
        diverged = "⇕⇡" + "$" + "{ahead_count}" + "⇣" + "$" + "{behind_count}";
        staged = "●" + "$" + "{count}";
        modified = "✚" + "$" + "{count}";
        renamed = "»" + "$" + "{count}";
        deleted = "⟂" + "$" + "{count}";
        untracked = "…" + "$" + "{count}";
        stashed = "≡";
      };

      nix_shell = { symbol = " "; format = " [$${symbol}$name]($style)"; style = "bold $palette.magenta"; };
      rust = { format = " [ $version]($style)"; style = "bold $palette.cyan"; };
      nodejs = { format = " [󰎙 $version]($style)"; style = "bold $palette.cyan"; };
      python = { format = " [ $virtualenv]($style)"; style = "bold $palette.cyan"; pyenv_version_name = true; };

      custom.zig = {
        description = "Zig toolchain";
        command = "zig version";
        when = "test -f build.zig -o -f build.zig.zon -o -f zig.zon";
        format = " [ $output]($style)";
        style = "bold $palette.cyan";
      };

      custom.copilot = {
        description = "GitHub Copilot active";
        command = "echo ";
        when = "test -n \"$GITHUB_COPILOT_ENABLED\"";
        format = "  [$output]($style)";
        style = "bold $palette.green";
      };

      package = { disabled = true; };
    };
  };
}
