# dotfiles

## New machine

```bash
git clone <this repo> && cd dotfiles && ./set_up.py
```

Installs [mise](https://mise.jdx.dev) (no sudo), copies configs into place (existing ones are backed up as `*.bak.<timestamp>`), installs system packages (pacman), the CLI tools listed in `mise/config.toml`, and the neovim (LazyVim plugins, Mason servers, treesitter parsers) and tmux (tpm) plugins, so everything works on first launch.

## Saving changes

`./sync.py` copies the live configs back into this repo. It skips `*.bak` files and tmux plugins, and strips the lines listed in `REDACTIONS` (e.g. password macros). Check `git diff` before committing anyway.
