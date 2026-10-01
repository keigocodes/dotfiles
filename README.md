# dotfiles

## New machine

```bash
git clone <this repo> && cd dotfiles && ./set_up.py
```

Installs [mise](https://mise.jdx.dev) (no sudo), copies configs into place (existing ones are backed up as `*.bak.<timestamp>`), and installs the CLI tools listed in `mise/config.toml`.

## Saving changes

`./sync.py` copies the live configs back into this repo.
