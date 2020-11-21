#!/usr/bin/env bash
#
# Works with $HOME/bin/ssh
# You ca use this by putting the following in your ssh/config:
# `SetEnv SSH_WRAPPER_SCRIPT="tmux_color.sh #550000"`
# The result would be to change tmux background color to "#550000" while connected to the remote host
# and revert the color to the default when disconnecting.
#

export SSH_WRAPPER_PRE=$(cat <<EOF
tmux select-pane -P bg=$1;
EOF
)

export SSH_WRAPPER_POST=$(cat <<EOF
tmux select-pane -P bg=default;
EOF
)
