{ config, pkgs, ... }:

{
  imports = [ ../common.nix ];

  home.username = "jack";
  home.homeDirectory = "/Users/jack";
  home.stateVersion = "25.11";

  programs.zsh = {
    oh-my-zsh.theme = "robbyrussell";
    initExtra = ''
      export PATH="$HOME/go/bin:$PATH"
      export PATH="/opt/homebrew/bin:$PATH"
      export PATH="/opt/homebrew/opt/sqlite/bin:$PATH"

      export PNPM_HOME="$HOME/Library/pnpm"
      case ":$PATH:" in
        *":$PNPM_HOME/bin:"*) ;;
        *) export PATH="$PNPM_HOME/bin:$PATH" ;;
      esac

      setopt GLOB_DOTS EXTENDED_HISTORY

      eval "$(direnv hook zsh)"
      [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
      [ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"
    '';
  };
}
