# Omarchy's shell setup (aliases, functions, history, readline) for machines without Omarchy.
# omarchy/ is a copy of /usr/share/omarchy/default/bash, refreshed by sync.py on an Omarchy machine.
# Sourced from ~/.bashrc after mise is activated, so eza/zoxide/etc. are already on PATH.

_omarchy_dir="$HOME/.config/bash/omarchy"

# Omarchy's envs point these at omarchy-launch-* helpers; use plain defaults instead
export EDITOR="${EDITOR:-nvim}"
export SUDO_EDITOR="${SUDO_EDITOR:-$EDITOR}"
export BAT_THEME=ansi
if command -v bat &>/dev/null; then
  export MANROFFOPT="-c"
  export MANPAGER="sh -c 'col -bx | bat -l man -p'"
fi

source "$_omarchy_dir/shell"
source "$_omarchy_dir/aliases"
for _f in "$_omarchy_dir"/fns/*; do source "$_f"; done

# Same as Omarchy's init, minus mise (done in ~/.bashrc) and its omarchy-only completions
if [[ ${TERM:-} != "dumb" ]] && command -v starship &>/dev/null; then
  eval "$(starship init bash)"
fi
if command -v zoxide &>/dev/null; then
  eval "$(zoxide init bash)"
fi
if command -v fzf &>/dev/null; then
  eval "$(fzf --bash)"
fi

bind -f "$_omarchy_dir/inputrc"

unset _omarchy_dir _f
