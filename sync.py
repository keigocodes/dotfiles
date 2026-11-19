#!/usr/bin/env python3
"""Copy dotfiles from their source locations into this repo."""

import shutil
from dataclasses import dataclass
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent
HOME = Path.home()

# Never copied into the repo: VCS data and backups left by set_up.py, Omarchy upgrades and editors.
IGNORE = (".git", "*.bak", "*.bak.*")


@dataclass(frozen=True)
class Source:
    src: Path
    dst_name: str | None = None
    preserve_symlinks: bool = True
    ignore: tuple[str, ...] = ()


SOURCES = [
    Source(HOME / ".config" / "omarchy"),
    Source(HOME / ".config" / "nvim"),
    Source(HOME / ".config" / "ghostty"),
    Source(HOME / ".config" / "hypr"),
    Source(HOME / ".config" / "fcitx5"),
    # Plugins are installed by tpm from tmux.conf (see set_up.py), so don't vendor them.
    Source(HOME / ".config" / "tmux", ignore=("plugins",)),
    Source(HOME / ".config" / "mise"),
    Source(HOME / ".config" / "bash"),
    Source(HOME / ".bashrc"),
    Source(HOME / ".claude" / "skills", dst_name="claude/skills", preserve_symlinks=False),
]

# Omarchy's bash setup, copied into ~/.config/bash so non-Omarchy machines get the same aliases.
OMARCHY_BASH = Path("/usr/share/omarchy/default/bash")
OMARCHY_BASH_COPY = HOME / ".config" / "bash" / "omarchy"

# Lines containing these markers are dropped from the copied file (keeps secrets out of the repo).
REDACTIONS = {
    Path("hypr/bindings.conf"): ["Auto-Password", "Auto-Email"],
    Path("hypr/bindings.lua"): ["Auto-Password", "Auto-Email"],
}


def redact(path: Path, markers: list[str]) -> None:
    if not path.exists():
        return
    lines = path.read_text().splitlines(keepends=True)
    path.write_text("".join(line for line in lines if not any(m in line for m in markers)))


def repo_path(source: Source) -> Path:
    return REPO_ROOT / (source.dst_name or source.src.name.lstrip("."))


def sync(source: Source) -> None:
    src = source.src
    dst = repo_path(source)

    if not src.exists():
        print(f"skip   {src} (does not exist)")
        return

    if dst.is_dir():
        shutil.rmtree(dst)
    elif dst.exists():
        dst.unlink()
    dst.parent.mkdir(parents=True, exist_ok=True)

    if src.is_file():
        shutil.copy2(src, dst, follow_symlinks=not source.preserve_symlinks)
    else:
        shutil.copytree(
            src,
            dst,
            symlinks=source.preserve_symlinks,
            ignore=shutil.ignore_patterns(*IGNORE, *source.ignore),
        )

    print(f"copied {src} -> {dst.relative_to(REPO_ROOT)}")


def copy_omarchy_bash() -> None:
    if not OMARCHY_BASH.exists():
        return
    if OMARCHY_BASH_COPY.exists():
        shutil.rmtree(OMARCHY_BASH_COPY)
    shutil.copytree(OMARCHY_BASH, OMARCHY_BASH_COPY)
    print(f"copied {OMARCHY_BASH} -> {OMARCHY_BASH_COPY}")


def main() -> None:
    copy_omarchy_bash()
    for source in SOURCES:
        sync(source)
    for rel_path, markers in REDACTIONS.items():
        redact(REPO_ROOT / rel_path, markers)
    print("You must verify that no public keys or passwords are exposed")


if __name__ == "__main__":
    main()
