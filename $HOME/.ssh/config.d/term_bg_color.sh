#!/usr/bin/env bash
#
# Works with $HOME/bin/ssh
# You ca use this by putting the following in your ssh/config:
# `SetEnv SSH_WRAPPER_SCRIPT="term_bg_color.sh 550000"`
# The result would be to change tmux background color to "550000" while connected to the remote host
# and revert the color to the default when disconnecting.
#
if [[ ${TERM_PROGRAM} == "tmux" ]]; then

  # Change the current pane color. $TMUX_PANE tells us what's the current pane_id in this context.
  export SSH_WRAPPER_PRE=$(cat <<EOF
tmux select-pane -t$TMUX_PANE -P bg=#$1;
EOF
  )

  export SSH_WRAPPER_POST=$(cat <<EOF
tmux select-pane -t$TMUX_PANE -P bg=default;
EOF
  )

elif [[ ${TERM_PROGRAM} == "iTerm.app" ]]; then

  # Change the current pane color. $TMUX_PANE tells us what's the current pane_id in this context.
  export SSH_WRAPPER_PRE=$(cat <<EOF
echo -e "\033]1337;SetColors=bg=$1\033\\\\"
EOF
  )

  export SSH_WRAPPER_POST=$(cat <<EOF
echo -e "\033]1337;SetColors=bg=000000\033\\\\"
EOF
  )

fi
