export PATH="$HOME/bin:$PATH"
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"
plugins=(git)
source $ZSH/oh-my-zsh.sh

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

alias ll="ls -lAh"
