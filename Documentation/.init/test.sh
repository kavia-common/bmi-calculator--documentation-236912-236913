#!/usr/bin/env bash
set -euo pipefail
WS_DEFAULT="/tmp/kavia/workspace/code-generation/bmi-calculator--documentation-236912-236913/Documentation"
WS="${WORKSPACE:-$WS_DEFAULT}"
cd "$WS"
command -v mkdocs >/dev/null || { echo "mkdocs not found on PATH; run env-001" >&2; exit 2; }
LOG=$(mktemp -u || true)
if [ -z "$LOG" ] || [ ! -w /tmp ]; then LOG="/tmp/mkdocs.build.$$"; fi
trap 'rm -f "$LOG" || true' EXIT
if ! mkdocs build --clean >"$LOG" 2>&1; then
  echo "mkdocs build failed; tail of log:" >&2
  tail -n 200 "$LOG" >&2 || true
  exit 6
fi
[ -f site/index.html ] || { echo "site/index.html not created" >&2; exit 5; }
grep -q "BMI Calculator Documentation" site/index.html || { echo "site title not found in built index.html" >&2; exit 7; }
exit 0
