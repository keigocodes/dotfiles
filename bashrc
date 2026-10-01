# If not running interactively, don't do anything (leave this at the top of this file)
[[ $- != *i* ]] && return

# All the default Omarchy aliases and functions
# (don't mess with these directly, just overwrite them here!)
# /etc/omarchy.conf is written by omarchy-dev-link. When absent, force the
# package default instead of preserving a stale inherited dev-link value before
# we decide which rc file to source.
if [[ -f /etc/omarchy.conf ]]; then
  source /etc/omarchy.conf
  export OMARCHY_PATH="${OMARCHY_PATH:-/usr/share/omarchy}"
else
  export OMARCHY_PATH=/usr/share/omarchy
fi
[[ -f "$OMARCHY_PATH/default/bash/rc" ]] && source "$OMARCHY_PATH/default/bash/rc"

# Add your own exports, aliases, and functions here.

[[ -f "$HOME/.local/bin/env" ]] && . "$HOME/.local/bin/env"
export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$PATH"

# Omarchy activates mise itself; do it here on machines without Omarchy
if [[ -z $MISE_SHELL ]] && command -v mise &>/dev/null; then
  eval "$(mise activate bash)"
fi

# My aliases
alias ti="~/.config/tmux/ti"
alias cld="claude --dangerously-skip-permissions"
alias moore="ssh ubx5728@moore.wot.eecs.northwestern.edu"
alias vicious="ssh ubx5728@vicious.cs.northwestern.edu"
alias quest="ssh ubx5728@login.quest.northwestern.edu"
alias globus-start="~/apps/globusconnectpersonal-3.2.8/globusconnectpersonal -start &"
alias py="python3 -ic 'import math'"
alias cl="clear"

# Whenever wifi cannot connect, go here in the browser: curl -v http://neverssl.com
