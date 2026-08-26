#!/usr/bin/env bash
# Install Knowz + KnowzCode into Grok Build from this marketplace repo.
# Safe to re-run. Requires `grok` on PATH.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"

if ! command -v grok >/dev/null 2>&1; then
  echo "grok CLI not found. Install Grok Build, then re-run." >&2
  exit 1
fi

echo "Adding marketplace from $ROOT"
grok plugin marketplace add "$ROOT" || true

echo "Installing knowz (--trust attaches MCP) and knowzcode"
grok plugin install knowz --trust
grok plugin install knowzcode --trust

if command -v knowz >/dev/null 2>&1; then
  echo "knowz CLI already on PATH: $(command -v knowz)"
else
  echo "Optional: npm i -g @knowzai/cli && knowz login"
fi

echo
echo "Start a new Grok session, then /knowz-status and /knowzcode:setup"
