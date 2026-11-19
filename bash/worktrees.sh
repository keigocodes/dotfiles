# Git worktree helpers (ported from Omarchy's default/bash/fns/worktrees).
# Works without Omarchy: gum and mise are used only if installed.
#
#   ga <branch>  create branch + worktree at ../<repo>--<branch> and cd into it
#   gd           from inside such a worktree: remove it and delete its branch

# Yes/no prompt; uses gum when available, plain read otherwise. Anything but yes = no.
_wt_confirm() {
  if command -v gum >/dev/null 2>&1; then
    gum confirm "$1"
  else
    local reply
    read -r -p "$1 [y/N] " reply
    [[ $reply == [yY] || $reply == [yY][eE][sS] ]]
  fi
}

# Create a new worktree and branch from within current git directory.
ga() {
  if [[ -z "$1" ]]; then
    echo "Usage: ga [branch name]"
    return 1
  fi

  local branch="$1"
  local base="$(basename "$PWD")"
  local wt_path="../${base}--${branch}"

  git worktree add -b "$branch" "$wt_path" || return 1
  command -v mise >/dev/null 2>&1 && mise trust "$wt_path"
  builtin cd "$wt_path"
}

# Remove worktree and branch from within active worktree directory.
gd() {
  if _wt_confirm "Remove worktree and branch?"; then
    local cwd branch root worktree

    cwd="$(pwd)"
    worktree="$(basename "$cwd")"

    # split on first `--`
    root="${worktree%%--*}"
    branch="${worktree#*--}"

    # Protect against accidentally nuking a non-worktree directory
    if [[ "$root" != "$worktree" ]]; then
      builtin cd "../$root" || return 1
      git worktree remove "$cwd" --force || return 1
      git branch -D "$branch"
    fi
  fi
}
