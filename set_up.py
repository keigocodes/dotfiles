#!/usr/bin/env python3
"""Set up a new machine: copy configs into place, then install system packages, mise tools, and nvim/tmux plugins."""

import shutil
import subprocess
import time
from pathlib import Path

from sync import HOME, REPO_ROOT, SOURCES, Source, repo_path

MISE = HOME / ".local" / "bin" / "mise"

# System packages not available through mise.
# neovim plus what LazyVim needs to build parsers and install Mason tools (go is for gopls etc.).
PACMAN_PACKAGES = [
    "pdftk",
    "tmux",
    "neovim",
    "git",
    "gcc",
    "make",
    "tree-sitter-cli",
    "unzip",
    "curl",
    "go",
]

NVIM_INSTALL_SCRIPT = REPO_ROOT / "nvim_install.lua"
TPM = HOME / ".config" / "tmux" / "plugins" / "tpm"


def restore(source: Source) -> None:
    src = repo_path(source)
    dst = source.src

    if not src.exists():
        print(f"skip   {src.relative_to(REPO_ROOT)} (not in repo)")
        return

    if dst.exists() or dst.is_symlink():
        backup = dst.with_name(f"{dst.name}.bak.{int(time.time())}")
        dst.rename(backup)
        print(f"backup {dst} -> {backup.name}")

    dst.parent.mkdir(parents=True, exist_ok=True)
    if src.is_file():
        shutil.copy2(src, dst, follow_symlinks=False)
    else:
        shutil.copytree(src, dst, symlinks=True)

    print(f"copied {src.relative_to(REPO_ROOT)} -> {dst}")


def install_system_packages() -> None:
    if not shutil.which("pacman"):
        print(f"skip   system packages (no pacman): {' '.join(PACMAN_PACKAGES)}")
        return
    subprocess.run(["sudo", "pacman", "-S", "--needed", "--noconfirm", *PACMAN_PACKAGES], check=True)


def install_tools() -> None:
    mise = shutil.which("mise") or str(MISE)
    if not Path(mise).exists():
        # Installs to ~/.local/bin; no sudo needed
        subprocess.run("curl -fsSL https://mise.run | sh", shell=True, check=True)
    subprocess.run([mise, "install"], check=True)
    # tealdeer ships without pages; fetch the cache once
    subprocess.run([mise, "exec", "--", "tldr", "--update"], check=True)


def install_nvim_plugins() -> None:
    nvim = shutil.which("nvim")
    if not nvim:
        print("skip   neovim plugins (nvim not installed)")
        return
    mise = shutil.which("mise") or str(MISE)
    # mise tools (node, etc.) on PATH so Mason can install npm-based servers
    subprocess.run(
        [mise, "exec", "--", nvim, "--headless", f"+luafile {NVIM_INSTALL_SCRIPT}"],
        check=True,
    )


def install_tmux_plugins() -> None:
    if not shutil.which("tmux"):
        print("skip   tmux plugins (tmux not installed)")
        return
    if not TPM.exists():
        subprocess.run(["git", "clone", "https://github.com/tmux-plugins/tpm", str(TPM)], check=True)
    # Installs the @plugin entries from tmux.conf; no running tmux server needed
    subprocess.run([TPM / "bin" / "install_plugins"], check=True)


def main() -> None:
    for source in SOURCES:
        restore(source)
    install_system_packages()
    install_tools()
    install_nvim_plugins()
    install_tmux_plugins()
    print("Done. Open a new shell to pick up the tools.")


if __name__ == "__main__":
    main()
