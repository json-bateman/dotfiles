{ config, pkgs, unstable, ... }:

# Dev toolchains, language servers and formatters. Imported on machines where
# code gets written (mac, redhat, laptop), not on servers.
{
  home.packages = with pkgs; [
    stylua
    lua-language-server
    pyright
    unstable.gopls
    unstable.delve # dlv, used by nvim-dap-go
    vscode-langservers-extracted
    prettier   # nvim conform formatter
    typescript # tsserver for typescript-tools.nvim
    unstable.go_latest # newest Go release; stable and unstable `go` lag behind
    unstable.golangci-lint
    templ
    sqlc
    air
    goose
    go-task # provides the `task` command
    unstable.gotools # goimports and other golang.org/x/tools commands
    nodejs # includes npm and npx
  ];

  programs.pyenv = {
    enable = true;
    enableZshIntegration = true;
    rootDirectory = "${config.home.homeDirectory}/.pyenv"; # keep existing installed versions
  };
}
