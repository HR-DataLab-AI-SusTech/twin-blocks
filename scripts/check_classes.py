"""Check every concrete class of TwinBlocks in OpenModelica's pinned image (check.mos), with the
libraries model.toml pins; fail on any error.

    uv run python scripts/check_classes.py
"""

from __future__ import annotations

import os
import subprocess
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent))
import model  # noqa: E402  -- the template's script: the libraries and the image

ROOT = Path(__file__).resolve().parents[1]


def main() -> None:
    library_path = ":".join(model.libraries())
    uid = f"{os.getuid()}:{os.getgid()}" if hasattr(os, "getuid") else "0:0"
    done = subprocess.run(  # noqa: S603 -- the image is model.toml's, pinned by digest
        [  # noqa: S607
            *("docker", "run", "--rm", "--network", "none", "--platform", "linux/amd64"),
            *("--user", uid, "-e", "HOME=/tmp", "-v", f"{ROOT}:/work", "-w", "/work"),
            *("-e", f"OPENMODELICALIBRARY={library_path}"),
            model.CONFIG["openmodelica_image"],
            *("omc", "check.mos"),
        ],
        capture_output=True,
        text=True,
        check=False,
    )
    print(done.stdout)
    failed = done.returncode != 0 or "Error" in done.stdout or "Check of" not in done.stdout
    if failed:
        print(done.stderr[-2000:], file=sys.stderr)
        raise SystemExit("a TwinBlocks class does not check")


if __name__ == "__main__":
    main()
