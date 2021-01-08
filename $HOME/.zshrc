export PATH="$HOME/bin:$PATH"
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"

plugins=(git tmux)

source $ZSH/oh-my-zsh.sh

# Tell zsh that sshrc should have the same autocompletion than ssh.
compdef sshrc=ssh

# Get rid of that annoying paste issue when I do CTRL+V before CTRL+SHIFT+V by mistake
bindkey -r "^V"

# Bigger history
HISTSIZE=100000

# Activate venv in current directory
if [[ -d ./venv ]]; then
    if [[ $PWD == $(realpath ~/) ]]; then
        export VIRTUAL_ENV_DISABLE_PROMPT=1
    fi
    source ./venv/bin/activate
    export VIRTUAL_ENV_DISABLE_PROMPT=
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
