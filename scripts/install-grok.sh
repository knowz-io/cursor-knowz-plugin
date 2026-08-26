#!/usr/bin/env bash
# Install Knowz + KnowzCode into Grok Build from this marketplace repo.
# Safe to re-run. Requires `grok` on PATH.
#
# Usage:
#   ./scripts/install-grok.sh
#   ./scripts/install-grok.sh --cli
#   ./scripts/install-grok.sh --replace-collisions
#   ./scripts/install-grok.sh --remote          # force GitHub even inside a clone
#   ./scripts/install-grok.sh --knowz-only
#   ./scripts/install-grok.sh --knowzcode-only
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
INSTALL_KNOWZ=1
INSTALL_KNOWZCODE=1
INSTALL_CLI=0
REPLACE_COLLISIONS=0
FORCE_REMOTE=0
FAIL=0

for arg in "$@"; do
  case "$arg" in
    --cli) INSTALL_CLI=1 ;;
    --replace-collisions) REPLACE_COLLISIONS=1 ;;
    --remote) FORCE_REMOTE=1 ;;
    --knowz-only) INSTALL_KNOWZ=1; INSTALL_KNOWZCODE=0 ;;
    --knowzcode-only) INSTALL_KNOWZ=0; INSTALL_KNOWZCODE=1 ;;
    -h|--help)
      awk 'NR==1{next} /^#/{sub(/^# ?/,""); print; next} {exit}' "$0"
      exit 0
      ;;
    *)
      echo "Unknown flag: $arg" >&2
      exit 1
      ;;
  esac
done

if ! command -v grok >/dev/null 2>&1; then
  echo "grok CLI not found. Install Grok Build, then re-run." >&2
  exit 1
fi

if [ "$FORCE_REMOTE" -eq 0 ] && [ -f "$ROOT/.grok-plugin/marketplace.json" ]; then
  MARKETPLACE="$ROOT"
  KNOWZ_SOURCE="$ROOT/plugins/knowz"
  KNOWZCODE_SOURCE="$ROOT/plugins/knowzcode"
  echo "Adding marketplace from clone: $ROOT"
else
  MARKETPLACE="knowz-io/cursor-knowz-plugin"
  KNOWZ_SOURCE="knowz-io/cursor-knowz-plugin#plugins/knowz"
  KNOWZCODE_SOURCE="knowz-io/cursor-knowz-plugin#plugins/knowzcode"
  echo "Adding marketplace: $MARKETPLACE"
fi

# Marketplace add is optional (enables browsing). Install uses #subdir / local
# plugin paths so a knowz-skills source cannot steal the name `knowz`.
grok plugin marketplace add "$MARKETPLACE" 2>/dev/null || true

list_json() {
  grok plugin list --json 2>/dev/null || echo '[]'
}

collision_sources() {
  python3 -c '
import json, sys
name = sys.argv[1]
try:
    data = json.load(sys.stdin)
except Exception:
    data = []
if isinstance(data, dict):
    data = data.get("plugins") or data.get("installed") or []
for p in data:
    if not isinstance(p, dict):
        continue
    if p.get("name") != name:
        continue
    src = str(p.get("source") or p.get("path") or "")
    key = str(p.get("repo_key") or p.get("id") or "")
    print(f"{key}\t{src}")
' "$1"
}

# Grok uninstall resolves a bare plugin name to the first registry match.
# Never call `grok plugin uninstall knowz` when two copies exist.
uninstall_collision() {
  local name="$1" key="$2" src="$3"
  echo "Uninstalling colliding $name via repo_key $key ($src)"
  if ! grok plugin uninstall "$key" --confirm; then
    echo "Grok did not uninstall repo_key $key. Refusing bare-name uninstall (it can delete this marketplace's copy)." >&2
    FAIL=1
    return 1
  fi
  if list_json | collision_sources "$name" | grep -F "$key" >/dev/null 2>&1; then
    echo "Collision $key is still installed after uninstall." >&2
    FAIL=1
    return 1
  fi
}

warn_or_replace() {
  local name="$1"
  local hits
  hits="$(list_json | collision_sources "$name" || true)"
  [ -n "$hits" ] || return 0
  local collision=0
  local keys=()
  local srcs=()
  while IFS=$'\t' read -r key src; do
    [ -n "$key$src" ] || continue
    case "$src" in
      *knowz-skills*)
        collision=1
        keys+=("$key")
        srcs+=("$src")
        echo "COLLISION: $name is also installed from knowz-skills:"
        echo "  $key  $src"
        ;;
    esac
  done <<< "$hits"
  if [ "$collision" -eq 0 ]; then
    return 0
  fi
  if [ "$REPLACE_COLLISIONS" -eq 1 ]; then
    local i
    for i in "${!keys[@]}"; do
      uninstall_collision "$name" "${keys[$i]}" "${srcs[$i]}"
    done
  else
    echo "Grok may load that copy instead of this slim plugin."
    echo "This script still installs from a pinned path. To drop the other copy:"
    echo "  $0 --replace-collisions"
    echo "Do not run: grok plugin uninstall $name   # ambiguous when duplicates exist"
  fi
}

install_one() {
  local source="$1"
  local name="$2"
  echo "Installing $name from $source (--trust)"
  local out
  set +e
  out="$(grok plugin install "$source" --trust 2>&1)"
  local status=$?
  set -e
  if [ "$status" -eq 0 ]; then
    printf '%s\n' "$out"
    grok plugin enable "$name" 2>/dev/null || true
    return 0
  fi
  case "$out" in
    *"already installed"*)
      echo "$name already installed from this source"
      grok plugin enable "$name" 2>/dev/null || true
      return 0
      ;;
  esac
  printf '%s\n' "$out" >&2
  echo "Failed to install $name from $source" >&2
  return "$status"
}

if [ "$INSTALL_KNOWZ" -eq 1 ]; then
  warn_or_replace knowz
fi
if [ "$INSTALL_KNOWZCODE" -eq 1 ]; then
  warn_or_replace knowzcode
fi

if [ "$INSTALL_KNOWZ" -eq 1 ]; then
  install_one "$KNOWZ_SOURCE" knowz
fi

if [ "$INSTALL_KNOWZCODE" -eq 1 ]; then
  install_one "$KNOWZCODE_SOURCE" knowzcode
fi

if [ "$INSTALL_CLI" -eq 1 ]; then
  if command -v npm >/dev/null 2>&1; then
    echo "Installing @knowzai/cli"
    npm i -g @knowzai/cli
    echo "Next: knowz login   (or knowz login --sso)"
  else
    echo "npm not found; --cli was requested. Install Node/npm, then: npm i -g @knowzai/cli && knowz login" >&2
    FAIL=1
  fi
elif command -v knowz >/dev/null 2>&1; then
  echo "knowz CLI already on PATH: $(command -v knowz)"
else
  echo "Optional (preferred for vaults, no MCP OAuth): npm i -g @knowzai/cli && knowz login"
  echo "  or pass --cli to this script"
fi

echo
echo "Installed:"
grok plugin list 2>/dev/null || true
echo
echo "Start a NEW Grok session (or press r in the Plugins tab)."
echo "Vaults: /knowz-status"
echo "  CLI:     knowz login, then /knowz-cli"
echo "  MCP:     /mcps → knowz → press i to OAuth"
echo "KnowzCode: /knowzcode:setup then /knowzcode:work"
echo "Do not paste API keys in chat. Do not run /knowz register on an existing account."
exit "$FAIL"
