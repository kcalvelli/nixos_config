# Development shell for Spec-Driven Development using GitHub Spec Kit
# Spec Kit is a methodology toolkit for building software from executable specifications
# rather than a traditional tech stack shell. It works with AI coding agents.
{ pkgs, inputs, system }:
let
  mkShell = inputs.devshell.legacyPackages.${system}.mkShell;
in
mkShell {
  name = "spec-kit";

  packages = [
    pkgs.python311
    pkgs.uv
    pkgs.git
    pkgs.gh
    pkgs.nodejs_20
  ];

  commands = [
    {
      name = "specify";
      help = "Run GitHub Spec Kit CLI via uvx";
      command = ''uvx --from git+https://github.com/github/spec-kit.git specify "$@"'';
    }
    {
      name = "spec-check";
      help = "Check Spec Kit prerequisites and detected AI agents";
      command = "specify check";
    }
    {
      name = "spec-init";
      help = "Initialize a new Spec-Driven Development project";
      command = "specify init \"$@\"";
    }
    {
      name = "spec-info";
      help = "Show information about this dev shell";
      command = ''
        echo "=== Spec-Kit Development Shell ==="
        echo "Purpose: Spec-Driven Development with GitHub Spec Kit"
        echo ""
        echo "Available commands:"
        echo "  specify      - Run Spec Kit CLI"
        echo "  spec-check   - Check prerequisites and AI agents"
        echo "  spec-init    - Initialize new project"
        echo "  spec-info    - Show this information"
        echo ""
        echo "Documentation: https://github.com/github/spec-kit"
        echo "Python: $(python --version)"
        echo "uv: $(uv --version)"
        echo "Node.js: $(node --version)"
      '';
    }
  ];

  env = [
    { name = "PIP_DISABLE_PIP_VERSION_CHECK"; value = "1"; }
    { name = "UV_NO_SYNC"; value = "1"; }
  ];
}
