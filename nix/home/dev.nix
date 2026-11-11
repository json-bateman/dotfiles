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
    awscli2 # `aws codeartifact` token for the work npm registry
  ];

  programs.pyenv = {
    enable = true;
    enableZshIntegration = true;
    rootDirectory = "${config.home.homeDirectory}/.pyenv"; # keep existing installed versions
  };

  # Node versions are per-project (legacy apps on 16, monorepo on 22), so mise
  # manages them instead of a single nixpkgs nodejs.
  programs.mise = {
    enable = true;
    enableZshIntegration = true;
    globalConfig.settings.idiomatic_version_file_enable_tools = [ "node" ];
  };
}
