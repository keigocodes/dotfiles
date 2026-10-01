#!/usr/bin/env python3
"""Copy dotfiles from their source locations into this repo.

With --restore, copy them from this repo back into place (e.g. on a new machine).
"""

import shutil
import sys
import time
from dataclasses import dataclass
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent
HOME = Path.home()


@dataclass(frozen=True)
class Source:
    src: Path
    dst_name: str | None = None
    preserve_symlinks: bool = True


SOURCES = [
    Source(HOME / ".config" / "omarchy"),
    Source(HOME / ".config" / "nvim"),
    Source(HOME / ".config" / "ghostty"),
    Source(HOME / ".config" / "hypr"),
    Source(HOME / ".config" / "fcitx5"),
    Source(HOME / ".config" / "tmux"),
    Source(HOME / ".config" / "mise"),
    Source(HOME / ".bashrc"),
    Source(HOME / ".claude" / "skills", dst_name="claude/skills", preserve_symlinks=False),
]

# Lines containing these markers are dropped from the copied file (keeps secrets out of the repo).
REDACTIONS = {
    Path("hypr/bindings.conf"): ["Auto-Password"],
}


def redact(path: Path, markers: list[str]) -> None:
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

    if src.is_file():
        if dst.exists():
            dst.unlink()
        dst.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(src, dst, follow_symlinks=not source.preserve_symlinks)
    else:
        if dst.exists():
            shutil.rmtree(dst)
        dst.parent.mkdir(parents=True, exist_ok=True)
        shutil.copytree(
            src,
            dst,
            symlinks=source.preserve_symlinks,
            ignore=shutil.ignore_patterns(".git"),
        )

    print(f"copied {src} -> {dst.relative_to(REPO_ROOT)}")


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


def main() -> None:
    if "--restore" in sys.argv[1:]:
        for source in SOURCES:
            restore(source)
        return

    for source in SOURCES:
        sync(source)
    for rel_path, markers in REDACTIONS.items():
        redact(REPO_ROOT / rel_path, markers)
    print("You must verify that no public keys or passwords are exposed")


if __name__ == "__main__":
    main()
