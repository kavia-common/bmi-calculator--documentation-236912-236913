#!/usr/bin/env bash
set -euo pipefail
WS_DEFAULT="/tmp/kavia/workspace/code-generation/bmi-calculator--documentation-236912-236913/Documentation"
WS="${WORKSPACE:-$WS_DEFAULT}"
mkdir -p "$WS" && cd "$WS"
mkdir -p docs
cat > docs/index.md <<'MD'
# BMI Calculator Documentation

Welcome to the BMI Calculator documentation.

MD
cat > docs/usage.md <<'MD'
# Usage

How to use the BMI calculator.

MD
cat > docs/installation.md <<'MD'
# Installation

Installation instructions for the BMI calculator.

MD
cat > docs/api.md <<'MD'
# API

API reference for the BMI calculator (if applicable).

MD
cat > mkdocs.yml <<'YML'
site_name: BMI Calculator Documentation
nav:
  - Home: index.md
  - Usage: usage.md
  - Installation: installation.md
  - API: api.md
YML
cat > .gitignore <<'G'
site/
*.pyc
__pycache__/
G
cat > README.md <<'R'
Simple MkDocs site. Use ./build.sh to build and ./serve.sh to preview locally.
MkDocs may be preinstalled in the container image when available.
R
cat > build.sh <<'B'
#!/usr/bin/env bash
set -euo pipefail
WS="${WS}"
cd "$WS"
mkdocs build --clean
B
chmod +x build.sh
cat > serve.sh <<'S'
#!/usr/bin/env bash
set -euo pipefail
WS="${WS}"
cd "$WS"
mkdocs serve --dev-addr=127.0.0.1:8000
S
chmod +x serve.sh
# initialize git repo idempotently
if [ ! -d .git ]; then
  git init -q || true
fi
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  if git config --get user.name >/dev/null && git config --get user.email >/dev/null; then
    git add -A >/dev/null || true
    git commit -m "scaffold mkdocs site" >/dev/null || true
  else
    echo "git user.name/user.email not set; skipping initial commit" >&2
  fi
fi
