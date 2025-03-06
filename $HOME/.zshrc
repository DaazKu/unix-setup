export ZSH="$HOME/.oh-my-zsh"
export GPG_TTY=$(tty)

export EDITOR="subl-new-window"

ZSH_THEME="robbyrussell"
# Disable bracketed-paste-magic which slows down large paste in terminal
DISABLE_MAGIC_FUNCTIONS=true

plugins=(git tmux tmux-cssh)

source $ZSH/oh-my-zsh.sh

# Tell zsh that sshrc should have the same autocompletion than ssh.
compdef sshrc=ssh

# Get rid of that annoying paste issue when I do CTRL+V before CTRL+SHIFT+V by mistake
bindkey -r "^V"

# Glob history search. Haaa yeah!!!
bindkey '^R' history-incremental-pattern-search-backward

# Bigger history
HISTSIZE=500000
setopt APPEND_HISTORY
setopt HIST_SAVE_NO_DUPS
setopt HIST_IGNORE_ALL_DUPS

# Adds stuff locally and to sshrc.
if [[ -f ~/.sharedrc ]]; then
  source ~/.sharedrc
fi

# Add extra stuff that should not be pushed to unix-setup
setopt nullglob
for rc in ~/.zshrc.d/*
do
    source $rc
done

export PATH="$HOME/bin:$PATH"

autoload -U +X bashcompinit && bashcompinit
complete -C `which terraform` terraform
complete -C `which terraform` terragf

export PATH="/opt/homebrew/opt/curl/bin:$PATH"

# Fast SSH host completion (cache :D)
# You can call `refresh_ssh_autocomplete` if you make any changes
# https://stackoverflow.com/a/64147638
function refresh_ssh_autocomplete() {
    host_list=(`grep -R 'Host ' ~/.ssh/ 2>/dev/null | grep -Pio 'host \K.+' | tr -s '\n' ' '`)
    zstyle ':completion:*:(ssh|scp|sftp|tmux-cssh):*' hosts $host_list
}
refresh_ssh_autocomplete

alias git-root='cd $(git rev-parse --show-toplevel || echo ".")'
export PATH="/opt/homebrew/opt/mysql-client@8.0/bin:$PATH"
