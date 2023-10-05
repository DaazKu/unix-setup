export ZSH="$HOME/.oh-my-zsh"
export GPG_TTY=$(tty)

export EDITOR="subl_new_window"

ZSH_THEME="robbyrussell"
# Disable bracketed-paste-magic which slows down large paste in terminal
DISABLE_MAGIC_FUNCTIONS=true

plugins=(git tmux)

source $ZSH/oh-my-zsh.sh

# Modified version from ~/.oh-my-zsh/lib/termsupport.zsh which update window title in tmux
# function title {
#   emulate -L zsh
#   setopt prompt_subst
#
#   [[ "$INSIDE_EMACS" == *term* ]] && return
#
#   # if $2 is unset use $1 as default
#   # if it is set and empty, leave it as is
#   : ${2=$1}
#
#   print $@
#
#   case "$TERM" in
#     cygwin|tmux*|xterm*|putty*|rxvt*|konsole*|ansi|mlterm*|alacritty|st*)
#       print -Pn "\e]2;${2:q}\a" # set window name
#       print -Pn "\e]1;${1:q}\a" # set tab name
#       ;;
#     screen*)
#       print -Pn "\ek${1:q}\e\\" # set screen hardstatus
#       ;;
#     *)
#       if [[ "$TERM_PROGRAM" == "iTerm.app" ]]; then
#         print -Pn "\e]2;${2:q}\a" # set window name
#         print -Pn "\e]1;${1:q}\a" # set tab name
#       else
#         # Try to use terminfo to set the title
#         # If the feature is available set title
#         if [[ -n "$terminfo[fsl]" ]] && [[ -n "$terminfo[tsl]" ]]; then
#           echoti tsl
#           print -Pn "$1"
#           echoti fsl
#         fi
#       fi
#       ;;
#   esac
# }


# Tell zsh that sshrc should have the same autocompletion than ssh.
compdef sshrc=ssh

# Get rid of that annoying paste issue when I do CTRL+V before CTRL+SHIFT+V by mistake
bindkey -r "^V"

# Glob history search. Haaa yeah!!!
bindkey '^R' history-incremental-pattern-search-backward

# Bigger history
HISTSIZE=100000
setopt APPEND_HISTORY

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

# Fast SSH host completion (cache :D)
# You can call `refresh_ssh_autocomplete` if you make any changes
# https://stackoverflow.com/a/64147638
function refresh_ssh_autocomplete() {
    host_list=(`grep -R 'Host ' ~/.ssh/ 2>/dev/null | awk '{s= s $2 " "} END {print s}'`)
    zstyle ':completion:*:(ssh|scp|sftp):*' hosts $host_list
}
refresh_ssh_autocomplete
