#!/usr/bin/env bash
set -euo pipefail
WS_DEFAULT="/tmp/kavia/workspace/code-generation/bmi-calculator--documentation-236912-236913/Documentation"
WS="${WORKSPACE:-$WS_DEFAULT}"
cd "$WS"
if ! command -v mkdocs >/dev/null; then
  echo "mkdocs not found on PATH; cannot build" >&2
  exit 4
fi
mkdocs build --clean
# verify site/index.html contains site title
if ! grep -q "BMI Calculator Documentation" site/index.html; then
  echo "built site/index.html does not contain expected site title" >&2
  exit 5
fi
