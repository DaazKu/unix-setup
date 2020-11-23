export PATH="$HOME/bin:$PATH"
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME_TERM_TITLE_TYPE=xterm
ZSH_THEME="robbyrussell"

# Do not automatically reconnect to previous session
ZSH_TMUX_AUTOCONNECT=false
# Launch tmux when opening Gnome Terminal
if [[ ! -z $GNOME_TERMINAL_SCREEN ]]; then
    ZSH_TMUX_AUTOSTART=true
fi

plugins=(git tmux)

source $ZSH/oh-my-zsh.sh

function omz_termsupport_precmd {
  local TERM=xterm # Fuck you I want my window title to change even in tmux!
  title "%n %4~ $h"
}

# Tell zsh that sshrc should have the same autocompletion than ssh.
compdef sshrc=ssh

# Get rid of that annoying paste issue when I do CTRL+V before CTRL+SHIFT+V by mistake
bindkey -r "^V"

# Activate venv in current directory
if [[ -d ./venv ]]; then
    if [[ $PWD == $(realpath ~/) ]]; then
        export VIRTUAL_ENV_DISABLE_PROMPT=1
    fi
    source ./venv/bin/activate
    export VIRTUAL_ENV_DISABLE_PROMPT=0
fi

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