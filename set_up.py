#!/usr/bin/env python3
"""Set up a new machine: copy configs from this repo into place and install CLI tools with mise."""

import shutil
import subprocess
import time
from pathlib import Path

from sync import HOME, REPO_ROOT, SOURCES, Source, repo_path

MISE = HOME / ".local" / "bin" / "mise"

# System packages not available through mise
PACMAN_PACKAGES = ["pdftk"]


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


def main() -> None:
    for source in SOURCES:
        restore(source)
    install_system_packages()
    install_tools()
    print("Done. Open a new shell to pick up the tools.")


if __name__ == "__main__":
    main()
