export PATH="$HOME/bin:$PATH"
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"

plugins=(git tmux)

source $ZSH/oh-my-zsh.sh

# Modified version from ~/.oh-my-zsh/lib/termsupport.zsh which update window title in tmux
function title {
  emulate -L zsh
  setopt prompt_subst

  [[ "$INSIDE_EMACS" == *term* ]] && return

  # if $2 is unset use $1 as default
  # if it is set and empty, leave it as is
  : ${2=$1}

  case "$TERM" in
    cygwin|tmux*|xterm*|putty*|rxvt*|konsole*|ansi|mlterm*|alacritty|st*)
      print -Pn "\e]2;${2:q}\a" # set window name
      print -Pn "\e]1;${1:q}\a" # set tab name
      ;;
    screen*|)
      print -Pn "\ek${1:q}\e\\" # set screen hardstatus
      ;;
    *)
      if [[ "$TERM_PROGRAM" == "iTerm.app" ]]; then
        print -Pn "\e]2;${2:q}\a" # set window name
        print -Pn "\e]1;${1:q}\a" # set tab name
      else
        # Try to use terminfo to set the title
        # If the feature is available set title
        if [[ -n "$terminfo[fsl]" ]] && [[ -n "$terminfo[tsl]" ]]; then
          echoti tsl
          print -Pn "$1"
          echoti fsl
        fi
      fi
      ;;
  esac
}


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
