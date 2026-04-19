{ ... }:
{
  flake.nixosModules.zsh =
    { pkgs, ... }:
    {
      users.defaultUserShell = pkgs.zsh;

      environment.systemPackages = with pkgs; [
        zsh
        atuin # ^R
        eza # ls
        git
      ];

      programs.zsh = {
        enable = true;
        enableCompletion = true;
        enableBashCompletion = true;
        enableGlobalCompInit = true;

        # autosuggetions.enable = true;
        # autosuggetions.strategy = [ "history" "completion" ];

        syntaxHighlighting.enable = true;
        syntaxHighlighting.highlighters = [
          "main"
          "brackets"
        ];

        histSize = 100000;

        # See `man zshoptions` for more details.
        setOptions = [
          # Remove duplicates continuously from command history (preserve newest entry).
          "HIST_IGNORE_DUPS"

          # Instantly share command history between all active shells.
          "SHARE_HISTORY" # Alternative to: "APPEND_HISTORY", "INC_APPEND_HISTORY",

          # Disable ^S and ^Z for less accidental freezing.
          "FLOW_CONTROL"

          # Save timestamp and duration of each command in command history.
          "EXTENDED_HISTORY"
        ];

        shellAliases = {
          # Navigation
          rm = "rm -iv";
          ls = "eza -lg";
          tree = "eza -lgT";

          # git
          gs = "git status";
          gd = "git diff";
          gdc = "git diff --cached";
          gca = "git commit --amend";
          gcv = "git commit --verbose";
          gap = "git add -p";
          gl = "git log --decorate=short --color | less -R";
          gpr = "git pull --rebase";
          gcp = "git cherry-pick";
        };

        promptInit = ''
          autoload -U promptinit
          promptinit
          prompt off

          # Simple:
          # PS1='[%n@%m:%~] %(!.#.$) '

          # Colorful:
          # PS1='[%F{green}%n@%m%f:%F{blue}%~%f] %(!.#.$) '

          # Colorful with git branch:
          function git_branch_name() {
            branch=$(git symbolic-ref HEAD --short 2>/dev/null)
            if [ ! -z "$branch" ]; then
              echo -n " [%F{red}$branch%f]"
            fi
          }

          # prompt='[%F{green}%n@%m%f:%F{blue}%~%f]$(git_branch_name) %(!.#.$) '

          # Omit username, print hostname + '$' with red when root, otherwise green:
          prompt='[%(!.%F{red}.%F{green})%m%f:%F{blue}%~%f]$(git_branch_name) %(!.%F{red}#%f.$) '

          # See: https://zsh.sourceforge.io/Doc/Release/Options.html#Prompting
          setopt prompt_cr
          setopt prompt_sp
          setopt prompt_subst

          export PROMPT_EOL_MARK=""
        '';

        interactiveShellInit = ''
          # Prevent user-level "config missing" message.
          touch $HOME/.zshrc

          # MacOS
          bindkey '^[[7~' beginning-of-line
          bindkey '^[[8~' end-of-line

          # Linux
          bindkey '^[[1;3D' beginning-of-line  # alt+left
          bindkey '^[[1;3C' end-of-line        # alt+right
          bindkey '^[[1;5D' backward-word      # ctrl+left
          bindkey '^[[1;5C' forward-word       # ctrl+right

          # Both
          bindkey '^R' history-incremental-search-backward
          bindkey '^U' kill-whole-line
          bindkey '^Y' yank

          # Compensate for modern terminals
          export TERM=xterm-256color

          # ^R
          eval "$(atuin init zsh --disable-up-arrow)"
        '';
      };
    };
}
