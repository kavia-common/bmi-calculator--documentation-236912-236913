#!/usr/bin/env bash
set -euo pipefail
WS_DEFAULT="/tmp/kavia/workspace/code-generation/bmi-calculator--documentation-236912-236913/Documentation"
WS="${WORKSPACE:-$WS_DEFAULT}"
# verify essentials
command -v python3 >/dev/null || { echo "python3 not found" >&2; exit 2; }
command -v pip3 >/dev/null || { echo "pip3 not found" >&2; exit 3; }
command -v git >/dev/null || { echo "git not found" >&2; exit 4; }
# check mkdocs; do not reinstall if present
MK_ON_PATH=$(command -v mkdocs || true)
if [ -n "$MK_ON_PATH" ]; then
  mkdocs --version || true
  exit 0
fi
# mkdocs not found on PATH; check pip-installed package availability
PYMKVERS=""
if python3 -c "import mkdocs, sys; print(getattr(mkdocs,'__version__',''))" >/dev/null 2>&1; then
  python3 -c "import mkdocs; print(mkdocs.__version__)"
  exit 0
fi
# If we reach here, mkdocs module not available; attempt user install
pip3 install --user --upgrade mkdocs >/dev/null
# ensure user base bin is on PATH for future shells via /etc/profile.d if needed
USER_BASE=$(python3 -c "import site; print(site.getuserbase())")
USER_BIN="$USER_BASE/bin"
if ! echo "$PATH" | tr ':' '\n' | grep -xq "$USER_BIN"; then
  if [ -w /etc/profile.d ]; then
    cat >/etc/profile.d/mkdocs_user_path.sh <<EOF
# added by scaffold install to expose pip user installs
export PATH="$USER_BIN:":"$PATH"
EOF
    chmod 0644 /etc/profile.d/mkdocs_user_path.sh || true
  fi
fi
# final check
if ! command -v mkdocs >/dev/null; then
  echo "mkdocs installed to user site; mkdocs not on PATH in this session." >&2
  echo "You may need to relogin or run: export PATH=\"$USER_BIN:\$PATH\"" >&2
  exit 0
fi
mkdocs --version
