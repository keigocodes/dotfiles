#!/usr/bin/env bash
# Set up a new machine: restore configs from this repo and install CLI tools with mise.
set -euo pipefail

cd "$(dirname "$0")"

if ! command -v mise &>/dev/null && [[ ! -x ~/.local/bin/mise ]]; then
  curl -fsSL https://mise.run | sh
fi
export PATH="$HOME/.local/bin:$PATH"

python3 sync.py --restore
mise install

echo "Done. Open a new shell to pick up the tools."
